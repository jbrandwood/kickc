package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.iterator.ProgramValue;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.statements.*;
import dk.camelot64.kickc.model.symbols.Label;
import dk.camelot64.kickc.model.symbols.Scope;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.symbols.VariableVersion;
import dk.camelot64.kickc.model.values.*;

import java.util.*;

/** Unroll Loops declared as inline. */
public class Pass2LoopUnroll extends Pass2SsaOptimization {

   public Pass2LoopUnroll(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      // Look for loops to unroll
      List<NaturalLoop> unrollLoops = findUnrollLoops(getProgram());
      // Is there any unrolling to do?
      if(unrollLoops.isEmpty()) {
         return false;
      }
      // Choose the candidate loop with the fewest blocks (and if several have the same number of blocks the first one encountered)
      NaturalLoop unrollLoop = chooseUnrollLoop(unrollLoops);
      getLog().append("Unrolling loop " + unrollLoop);

      // Unroll the first iteration of the loop

      // 0. Unroll Symbols
      // - Create new versions of all symbols assigned inside the loop
      Map<VariableRef, VariableRef> definedToNewVar = copyVarsDefinedInLoop(unrollLoop);

      // - Create new labels for all blocks in the loop
      Map<LabelRef, LabelRef> blockToNewBlock = copyBlocksInLoop(unrollLoop);

      // 1. Copy all loop blocks to create the "rest of the loop" and modifying the existing loop to only be the first iteration)
      //  - Unroll Statements (copy all statements, replace symbols properly (with the new versions / the versions assigned in the existing loop)
      //    - Includes unrolling PHI-statements properly
      //  - Unroll Successors (loop-exit successors should point to the same exit, loop-internal successors should point to the new loop-internal block)
      for(ControlFlowBlock block : unrollLoop.getBlocks(getGraph())) {
         // Create the new block
         LabelRef newBlockLabel = unrollLabel(block.getLabel(), blockToNewBlock);
         ControlFlowBlock newBlock = new ControlFlowBlock(newBlockLabel, block.getScope());
         getProgram().getGraph().addBlock(newBlock);
         for(Statement statement : block.getStatements()) {
            Statement newStatement = unrollStatement(statement, unrollLoop, blockToNewBlock, definedToNewVar);
            newBlock.addStatement(newStatement);
            if(newStatement instanceof StatementConditionalJump) {
               newBlock.setConditionalSuccessor(((StatementConditionalJump) newStatement).getDestination());
            }
         }
         newBlock.setDefaultSuccessor(unrollLabel(block.getDefaultSuccessor(), blockToNewBlock));
      }

      // Patch the "old loop" to only contain the first iteration
      for(ControlFlowBlock block : unrollLoop.getBlocks(getGraph())) {
         //  - All successors in the old loop to the loop head should point to the new loop head instead.

         // If the successor is the loop head then update to the new copied loop head instead
         block.setDefaultSuccessor(fixSuccessor(block.getDefaultSuccessor(), blockToNewBlock, unrollLoop));

         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementPhiBlock) {
               //  - Remove phi-variables in the old head from looping. (as this predecessor now no longer exists)
               for(StatementPhiBlock.PhiVariable phiVariable : ((StatementPhiBlock) statement).getPhiVariables()) {
                  List<StatementPhiBlock.PhiRValue> phiVariableValues = phiVariable.getValues();
                  ListIterator<StatementPhiBlock.PhiRValue> phiRValueListIterator = phiVariableValues.listIterator();
                  while(phiRValueListIterator.hasNext()) {
                     StatementPhiBlock.PhiRValue phiRValue = phiRValueListIterator.next();
                     if(unrollLoop.getBlocks().contains(phiRValue.getPredecessor())) {
                        // Found predecessor inside the same loop - remove it!
                        phiRValueListIterator.remove();
                     }
                  }
               }
            } else if(statement instanceof StatementConditionalJump) {
               //  - Remove the "unroll" directive on the condition in the old loop (as it is already unrolled).
               // MAYBE: Only remove "unroll" from the conditional that represents the loop we are unrolling
               StatementConditionalJump conditionalJump = (StatementConditionalJump) statement;
               if(conditionalJump.isDeclaredUnroll()) {
                  // Mark is unrolled - to ensure it is removed before unrolling more
                  conditionalJump.setWasUnrolled(true);
                  // Remove unroll declaration - now only the "rest" of the loop needs unrolling
                  conditionalJump.setDeclaredUnroll(false);
               }
               // Fix the destination (if needed)!
               LabelRef fixedDestination = fixSuccessor(conditionalJump.getDestination(), blockToNewBlock, unrollLoop);
               conditionalJump.setDestination(fixedDestination);
               block.setConditionalSuccessor(fixedDestination);
            }
         }
      }

      // Update phi-blocks in loop successors to also include the new unrolled "rest" loop
      List<LoopSuccessorBlock> loopSuccessorBlocks = getLoopSuccessorBlocks(unrollLoop, getGraph());
      for(LoopSuccessorBlock loopSuccessorBlock : loopSuccessorBlocks) {
         ControlFlowBlock successorBlock = getGraph().getBlock(loopSuccessorBlock.successor);
         StatementPhiBlock phiBlock = successorBlock.getPhiBlock();
         for(StatementPhiBlock.PhiVariable phiVariable : phiBlock.getPhiVariables()) {
            for(StatementPhiBlock.PhiRValue phiRValue : phiVariable.getValues()) {
               if(unrollLoop.getBlocks().contains(phiRValue.getPredecessor())) {
                  // Found a phi variable with values from the poriginal loop in a loop successor block
                  // Add another value when entering from the unrolled loop
                  phiVariable.setrValue(unrollLabel(phiRValue.getPredecessor(), blockToNewBlock), unrollValue(phiRValue.getrValue(), definedToNewVar));
                  break;
               }
            }
         }
      }

      return true;
   }

   /**
    * Fix a successor block in the original loop (that is now only the first iteration).
    *
    * @param successor The successor
    * @param blockToNewBlock The map from loop blocks to the corresponding unrolled "rest" loop blocks.
    * @param unrollLoop The loop being unrolled
    * @return The fixed successor label
    */
   private LabelRef fixSuccessor(LabelRef successor, Map<LabelRef, LabelRef> blockToNewBlock, NaturalLoop unrollLoop) {
      LabelRef fixed;
      if(unrollLoop.getHead().equals(successor)) {
         fixed = blockToNewBlock.get(successor);
      } else {
         fixed = successor;
      }
      return fixed;
   }

   /**
    * Unroll a single statement inside a loop.
    * Copy the statement, replace symbols properly (with the new versions if needed). This includes unrolling loop PHI-statements properly
    * Unroll Successors (loop-exit successors should point to the same exit, loop-internal successors should point to the new loop-internal block)
    *
    * @param statement The statement to unroll
    * @param unrollLoop The loop being unrolled
    * @param blockToNewBlock Map from loop block label to the label of the copied block in the new (rest) loop
    * @param definedToNewVar Map from variables defined in the loop to the copied variable in the new (rest) loop
    * @return The copied & unrolled statement
    */
   private Statement unrollStatement(Statement statement, NaturalLoop unrollLoop, Map<LabelRef, LabelRef> blockToNewBlock, Map<VariableRef, VariableRef> definedToNewVar) {
      if(statement instanceof StatementPhiBlock) {
         StatementPhiBlock phiBlock = (StatementPhiBlock) statement;
         StatementPhiBlock newPhiBlock = new StatementPhiBlock();
         for(StatementPhiBlock.PhiVariable phiVariable : phiBlock.getPhiVariables()) {
            VariableRef phiVar = phiVariable.getVariable();
            VariableRef newVar = definedToNewVar.get(phiVar);
            StatementPhiBlock.PhiVariable newPhiVariable = newPhiBlock.addPhiVariable(newVar);
            for(StatementPhiBlock.PhiRValue phiRValue : phiVariable.getValues()) {
               LabelRef predecessor = phiRValue.getPredecessor();
               if(unrollLoop.getBlocks().contains(predecessor)) {
                  // Predecessor inside the loop - create two copies (one from the original loop block and onw from the new copy)
                  // Entering from iteration 1 use the original value from iteration 1
                  RValue rValue = copyValue(phiRValue.getrValue());
                  newPhiVariable.setrValue(predecessor, rValue);
                  // Entering from the new rest-of-loop block perform a mapping replacing all references to variables inside the loop to the new versions.
                  RValue rValueNew = unrollValue(phiRValue.getrValue(), definedToNewVar);
                  newPhiVariable.setrValue(unrollLabel(predecessor, blockToNewBlock), rValueNew);
               } else {
                  // Predecessor outside loop - do not copy since all entry to the copy of the loop will be through the first iteration
               }
            }
         }
         return newPhiBlock;
      } else if(statement instanceof StatementAssignment) {
         StatementAssignment assignment = (StatementAssignment) statement;
         return new StatementAssignment(
               (LValue) unrollValue(assignment.getlValue(), definedToNewVar),
               unrollValue(assignment.getrValue1(), definedToNewVar),
               assignment.getOperator(),
               unrollValue(assignment.getrValue2(), definedToNewVar),
               assignment.getSource()
         );
      } else if(statement instanceof StatementConditionalJump) {
         StatementConditionalJump conditional = (StatementConditionalJump) statement;
         LabelRef labelRef = conditional.getDestination();
         StatementConditionalJump newConditional = new StatementConditionalJump(
               unrollValue(conditional.getrValue1(), definedToNewVar),
               conditional.getOperator(),
               unrollValue(conditional.getrValue2(), definedToNewVar),
               unrollLabel(labelRef, blockToNewBlock),
               conditional.getSource()
         );
            newConditional.setDeclaredUnroll(conditional.isDeclaredUnroll());
         return newConditional;
      } else {
         throw new RuntimeException("Statement not handled by unroll " + statement);
      }
   }

   /**
    * If the passed label is from the original loop return the corresponding label from the unrolled "rest" loop
    * Otherwise the passed label is returned.
    *
    * @param labelRef The label
    * @param blockToNewBlock Maps labels from the original loop to the new labels in the unrolled "rest" loop.
    * @return The label to use in the unrolled loop
    */
   private LabelRef unrollLabel(LabelRef labelRef, Map<LabelRef, LabelRef> blockToNewBlock) {
      LabelRef unrolledLabel = blockToNewBlock.get(labelRef);
      if(unrolledLabel == null) {
         return labelRef;
      } else {
         return unrolledLabel;
      }
   }

   /**
    * Update all variable references in an RValue that point to variables inside the loop to the new unrolled "rest" loop.
    *
    * @param rValue The rValue to update
    * @param definedToNewVar Map from variables defined in the original loop to the variables in the new unrolled "rest" loop
    * @return A copy of the RValue with all relevant variable sreferences updated
    */
   private RValue unrollValue(RValue rValue, Map<VariableRef, VariableRef> definedToNewVar) {
      if(rValue == null) return null;
      RValue rValueCopy = copyValue(rValue);
      ProgramValue.GenericValue genericValue = new ProgramValue.GenericValue(rValueCopy);
      ProgramValueIterator.execute(genericValue, (programValue, currentStmt, stmtIt, currentBlock) -> {
         RValue rVal = programValue.get();
         if(rVal instanceof VariableRef) {
            if(definedToNewVar.get(rVal) != null) {
               programValue.set(definedToNewVar.get(rVal));
            }
         }
      }, null, null, null);
      return genericValue.get();
   }

   /**
    * Create a copy of the passed value object (to avoid that two parts of the model points to the same object).
    *
    * @param rValue The value to copy
    * @return An exact copy of the value
    */
   private RValue copyValue(RValue rValue) {
      if(rValue == null) return null;
      ProgramValue.GenericValue genericValue = new ProgramValue.GenericValue(rValue);
      ProgramValueIterator.execute(genericValue, (programValue, currentStmt, stmtIt, currentBlock) -> {
         RValue rVal = programValue.get();
         if(rVal instanceof PointerDereferenceSimple) {
            programValue.set(new PointerDereferenceSimple(((PointerDereferenceSimple) rVal).getPointer()));
         } else if(rVal instanceof PointerDereferenceIndexed) {
            programValue.set(new PointerDereferenceIndexed(((PointerDereferenceIndexed) rVal).getPointer(), ((PointerDereferenceIndexed) rVal).getIndex()));
         } else if(rVal instanceof CastValue) {
            programValue.set(new CastValue(((CastValue) rVal).getToType(), ((CastValue) rVal).getValue()));
         } else if(rVal instanceof ValueList) {
            programValue.set(new ValueList(new ArrayList<>(((ValueList) rVal).getList())));
         }
      }, null, null, null);
      return genericValue.get();
   }

   /**
    * Copy all blocks in a loop. The new copies are named from the original name plus an integer suffix.
    *
    * @param unrollLoop The loop being copied
    * @return A map from each block label (from the loop) to the new copied labels
    */
   private Map<LabelRef, LabelRef> copyBlocksInLoop(NaturalLoop unrollLoop) {
      LinkedHashMap<LabelRef, LabelRef> blockToNewBlock = new LinkedHashMap<>();
      for(ControlFlowBlock block : unrollLoop.getBlocks(getGraph())) {
         Scope blockScope = getScope().getScope(block.getScope());
         // Find the serial number
         int unrollSerial = 1;
         String localName = block.getLabel().getLocalName();
         int serialPos = localName.lastIndexOf("_");
         if(serialPos>=0) {
            localName = localName.substring(0, serialPos);
         }

         String unrollLabelName;
         do {
            unrollLabelName = localName + "_" + unrollSerial++;
         } while(blockScope.getLabel(unrollLabelName) != null);
         // Create a label
         Label unrollLabel = blockScope.addLabel(unrollLabelName);
         blockToNewBlock.put(block.getLabel(), unrollLabel.getRef());
      }
      return blockToNewBlock;
   }

   /**
    * Create new versions of all symbols assigned inside the loop
    *
    * @param unrollLoop The loop being unrolled
    * @return A map from variables assigned inside the loop to the new copy of the variable
    */
   private Map<VariableRef, VariableRef> copyVarsDefinedInLoop(NaturalLoop unrollLoop) {
      Map<VariableRef, VariableRef> definedToNewVar = new LinkedHashMap<>();
      for(VariableRef definedVarRef : getVarsDefinedInLoop(unrollLoop, getProgram())) {
         Variable definedVar = getScope().getVariable(definedVarRef);
         Variable newVar;
         if(definedVarRef.isIntermediate()) {
            newVar = definedVar.getScope().addVariableIntermediate();
            newVar.setType(definedVar.getType());
            newVar.setDeclaredRegister(definedVar.getDeclaredRegister());
            newVar.setDeclaredVolatile(definedVar.isDeclaredVolatile());
            newVar.setDeclaredAlignment(definedVar.getDeclaredAlignment());
            newVar.setInferredType(definedVar.isInferredType());
         } else if(definedVarRef.isVersion()) {
            newVar = ((VariableVersion) definedVar).getVersionOf().createVersion();
         } else {
            throw new RuntimeException("Error! Variable is not versioned or intermediate " + definedVar.toString(getProgram()));
         }
         definedToNewVar.put(definedVarRef, newVar.getRef());
         //getLog().append("Defined in loop: " + definedVarRef.getFullName() + " -> " + newVar.getRef().getFullName());
      }
      return definedToNewVar;
   }

   /**
    * Choose which loop to unroll first from a candidate set.
    * The smallest loop (fewest control flow blocks) is chosen.
    * If multiple loops have the same size the first one is chosen.
    *
    * @param unrollLoopCandidates All loops that are declared to be unrolled
    * @return The loop to unroll first.
    */
   private static NaturalLoop chooseUnrollLoop(List<NaturalLoop> unrollLoopCandidates) {
      NaturalLoop unrollLoop = null;
      for(NaturalLoop unrollLoopCandidate : unrollLoopCandidates) {
         if(unrollLoop == null) {
            unrollLoop = unrollLoopCandidate;
         } else {
            if(unrollLoopCandidate.getBlocks().size() < unrollLoop.getBlocks().size()) {
               unrollLoop = unrollLoopCandidate;
            }
         }
      }
      return unrollLoop;
   }

   /**
    * Find all loops declared for unrolling. This is done by examining all conditional jumps, which hold the loop unroll declaration.
    *
    * @param program The program
    * @return All loops declared to be unrolled
    */
   static List<NaturalLoop> findUnrollLoops(Program program) {
      NaturalLoopSet loops = program.getLoopSet();
      List<NaturalLoop> unrollLoopCandidates = new ArrayList<>();
      for(ControlFlowBlock block : program.getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementConditionalJump) {
               if(((StatementConditionalJump) statement).isDeclaredUnroll()) {
                  // Found a candidate for unrolling - identify the loop
                  for(NaturalLoop loopCandidate : loops.getLoopsContainingBlock(block.getLabel())) {
                     if(!loopCandidate.getBlocks().contains(block.getConditionalSuccessor())) {
                        // The conditional jump exits the loopCandidate - so we have identified the right one!
                        unrollLoopCandidates.add(loopCandidate);
                        break;
                     } else if(!loopCandidate.getBlocks().contains(block.getDefaultSuccessor())) {
                        // The default successor of the conditional exits the loopCandidate - so we have identified the right one!
                        unrollLoopCandidates.add(loopCandidate);
                        break;
                     }
                  }
               }
            }
         }
      }
      return unrollLoopCandidates;
   }

   /**
    * Get all variables defined inside a loop
    *
    * @param loop The loop
    * @param program The program
    * @return All variables defined inside the blocks of the loop
    */
   static List<VariableRef> getVarsDefinedInLoop(NaturalLoop loop, Program program) {
      VariableReferenceInfos variableReferenceInfos = program.getVariableReferenceInfos();
      List<VariableRef> definedInLoop = new ArrayList<>();
      for(ControlFlowBlock block : loop.getBlocks(program.getGraph())) {
         for(Statement statement : block.getStatements()) {
            Collection<VariableRef> definedVars = variableReferenceInfos.getDefinedVars(statement);
            for(VariableRef definedVarRef : definedVars) {
               definedInLoop.add(definedVarRef);
            }
         }
      }
      return definedInLoop;
   }

   /** Information about a block succeeding a loop - ie. a place where the flow of control leaves a loop. */
   public static class LoopSuccessorBlock {
      /** A block that is the successor to a block inside the loop. */
      LabelRef successor;
      /** The block inside the loop that is the predecessor of the loop successor block. */
      LabelRef predecessor;

      public LoopSuccessorBlock(LabelRef successor, LabelRef predecessor) {
         this.successor = successor;
         this.predecessor = predecessor;
      }
   }

   /**
    * Find all transitions where the flow of control leaves a loop
    *
    * @param loop The loop to examine
    * @param graph The control flow graph
    * @return
    */
   static List<LoopSuccessorBlock> getLoopSuccessorBlocks(NaturalLoop loop, ControlFlowGraph graph) {
      List<LoopSuccessorBlock> loopSuccessors = new ArrayList<>();
      for(ControlFlowBlock block : loop.getBlocks(graph)) {
         if(block.getDefaultSuccessor() != null && !loop.getBlocks().contains(block.getDefaultSuccessor())) {
            // Default successor is outside
            loopSuccessors.add(new LoopSuccessorBlock(block.getDefaultSuccessor(), block.getLabel()));
         }
         if(block.getConditionalSuccessor() != null && !loop.getBlocks().contains(block.getConditionalSuccessor())) {
            // Conditional successor is outside
            loopSuccessors.add(new LoopSuccessorBlock(block.getConditionalSuccessor(), block.getLabel()));
         }
      }
      return loopSuccessors;
   }

   static boolean isReferencedOutsideLoop(VariableRef definedVarRef, NaturalLoop unrollLoop, Program program) {
      boolean referencedOutsideLoop = false;
      VariableReferenceInfos variableReferenceInfos = program.getVariableReferenceInfos();
      Collection<Integer> varRefStatements = variableReferenceInfos.getVarRefStatements(definedVarRef);
      for(Integer varRefStatement : varRefStatements) {
         StatementInfos statementInfos = program.getStatementInfos();
         ControlFlowBlock refBlock = statementInfos.getBlock(varRefStatement);
         if(!unrollLoop.getBlocks().contains(refBlock.getLabel())) {
            referencedOutsideLoop = true;
            break;
         }
      }
      return referencedOutsideLoop;
   }

}
