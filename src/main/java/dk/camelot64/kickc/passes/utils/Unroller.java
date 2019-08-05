package dk.camelot64.kickc.passes.utils;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.iterator.ProgramValue;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.statements.*;
import dk.camelot64.kickc.model.symbols.Label;
import dk.camelot64.kickc.model.symbols.Scope;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.symbols.VariableVersion;
import dk.camelot64.kickc.model.values.*;
import dk.camelot64.kickc.passes.AliasReplacer;

import java.util.*;

/**
 * Utility for copying blocks in a program - typically to unroll loops or conditions.
 * <p>
 * Unrolling has a number of phases
 * <ol>
 * <li>Prepare by ensuring that all successors of the blocks have PHI-statements for all variables defined inside the blocks </li>
 * <li>Copy all variables defined inside the blocks </li>
 * <li>Copy all block labels</li>
 * <li>Copy all blocks & statements - rewriting  all internal transitions in both original and copy according to a strategy.</li>
 * <li>Patch all predecessor blocks so they hit either the original or the new copied block according to a strategy.</li>
 * <li>Patch all successor blocks so they are now hit by both original and copy.</li>
 * </ol>
 * <p>
 * The {@link UnrollStrategy} defines
 * <ul>
 * <li> For each block transition entering the blocks being copied - should the transition hit the original or the copy?</li>
 * <li> For each block transition between two blocks being copied - should the transition be copied, always hit the original or always hit the copy?</li>
 * </ul>
 */
public class Unroller {

   /** The program. */
   private Program program;
   /** The blocks being copied/unrolled. */
   private BlockSet unrollBlocks;
   /** The strategy used for rewriting transitions into the block / inside the block. */
   private UnrollStrategy strategy;
   /** Maps variables defined in the original block to the copies of these variables defined in the new block. */
   private Map<VariableRef, VariableRef> varsOriginalToCopied;
   /** Maps labels of blocks in the original block to the labels of the copied blocks. */
   private Map<LabelRef, LabelRef> blocksOriginalToCopied;

   public Unroller(Program program, BlockSet unrollBlocks, UnrollStrategy unrollStrategy) {
      this.program = program;
      this.unrollBlocks = unrollBlocks;
      this.strategy = unrollStrategy;
   }

   /**
    * Perform unrolling by copying all specified blocks and updating block transitions according to the strategy
    */
   public void unroll() {
      // 0. Prepare for copying by ensuring that all variables defined in the blocks are represented in PHI-blocks of the successors
      prepare();

      if(program.getLog().isVerboseSSAOptimize()) {
         program.getLog().append("CONTROL FLOW GRAPH (PREPARED)");
         program.getLog().append(program.getGraph().toString(program));
      }

      // 1. Create new versions of all symbols assigned inside the loop
      this.varsOriginalToCopied = copyDefinedVars(unrollBlocks, program);
      // 2. Create new labels for all blocks in the loop
      this.blocksOriginalToCopied = copyBlockLabels(unrollBlocks, program);
      // 3. Copy all blocks being unrolled - rewriting internal transitions in both original and copy according to strategy
      unrollBlocks();
   }

   /**
    * Ensure that all variables defined inside the blocks to be copied has a PHI in successor blocks.
    */
   private void prepare() {
      for(VariableRef origVarRef : getVarsDefinedIn(unrollBlocks, program)) {
         // Find out if the variable is ever referenced outside the loop
         if(isReferencedOutside(origVarRef, unrollBlocks, program)) {
            //  Add any needed PHI-statements to the successors
            for(SuccessorTransition successorTransition : getSuccessorTransitions(unrollBlocks, program.getGraph())) {
               ControlFlowBlock successorBlock = program.getGraph().getBlock(successorTransition.successor);
               StatementPhiBlock phiBlock = successorBlock.getPhiBlock();
               // Create a new version of the variable
               Variable origVar = program.getScope().getVariable(origVarRef);
               Variable newVar;
               if(origVar instanceof VariableVersion) {
                  newVar = ((VariableVersion) origVar).getVersionOf().createVersion();
               } else {
                  newVar = origVar.getScope().addVariableIntermediate();
               }
               // Replace all references from the new phi and forward
               forwardReplaceAllUsages(successorTransition.successor, origVarRef, newVar.getRef(), new LinkedHashSet<>());
               // Create the new phi-variable in the successor phi block
               StatementPhiBlock.PhiVariable newPhiVar = phiBlock.addPhiVariable(newVar.getRef());
               newPhiVar.setrValue(successorTransition.predecessor, origVarRef);
               program.getLog().append("Creating PHI for " + origVarRef.getFullName() + " in block " + successorBlock.getLabel() + " - " + phiBlock.toString(program, false));

            }
         }
      }
   }

   /**
    * Introduces a new version of a variable - and replaces all uses of the old variable with the new one from a specific point in the control flow graph and forward until the old variable is defined.
    * @param blockRef The block to replace the usage from
    * @param origVarRef The original variable
    * @param newVarRef The new variable replacing the original
    * @param visited All blocks that have already been visited.
    */
   private void forwardReplaceAllUsages(LabelRef blockRef, VariableRef origVarRef, VariableRef newVarRef, Set<LabelRef> visited) {
      VariableReferenceInfos variableReferenceInfos = program.getVariableReferenceInfos();
      LinkedHashMap<SymbolRef, RValue> aliases = new LinkedHashMap<>();
      aliases.put(origVarRef, newVarRef);
      AliasReplacer aliasReplacer = new AliasReplacer(aliases);
      ControlFlowBlock block = program.getGraph().getBlock(blockRef);
      if(block!=null) {
         for(Statement statement : block.getStatements()) {
            Collection<VariableRef> definedVars = variableReferenceInfos.getDefinedVars(statement);
            if(definedVars!=null && definedVars.contains(origVarRef)) {
               // Found definition of the original variable - don't replace any more
               return;
            }
            // Replace any usage in the statement
            ProgramValueIterator.execute(statement, aliasReplacer, null, block);
         }
      }
      visited.add(blockRef);
      if(block!=null) {
         if(block.getConditionalSuccessor() != null && !visited.contains(block.getConditionalSuccessor())) {
            forwardReplaceAllUsages(block.getConditionalSuccessor(), origVarRef, newVarRef, visited);
         }
         if(block.getDefaultSuccessor() != null && !visited.contains(block.getDefaultSuccessor())) {
            forwardReplaceAllUsages(block.getDefaultSuccessor(), origVarRef, newVarRef, visited);
         }
         if(block.getCallSuccessor() != null && !visited.contains(block.getCallSuccessor())) {
            forwardReplaceAllUsages(block.getCallSuccessor(), origVarRef, newVarRef, visited);
         }
      }
   }

   /**
    * Create new versions of all symbols assigned inside some blocks to be unrolled
    *
    * @param unrollBlocks The blocks being unrolled
    * @return A map from variables assigned inside the unroll blocks to the new copy of the variable
    */
   private static Map<VariableRef, VariableRef> copyDefinedVars(BlockSet unrollBlocks, Program program) {
      Map<VariableRef, VariableRef> definedToNewVar = new LinkedHashMap<>();
      for(VariableRef definedVarRef : getVarsDefinedIn(unrollBlocks, program)) {
         Variable definedVar = program.getScope().getVariable(definedVarRef);
         Variable newVar;
         if(definedVarRef.isIntermediate()) {
            newVar = definedVar.getScope().addVariableIntermediate();
            newVar.setType(definedVar.getType());
            newVar.setDeclaredRegister(definedVar.getDeclaredRegister());
            newVar.setDeclaredVolatile(definedVar.isDeclaredVolatile());
            newVar.setInferedVolatile(definedVar.isInferedVolatile());
            newVar.setDeclaredAlignment(definedVar.getDeclaredAlignment());
            newVar.setInferredType(definedVar.isInferredType());
         } else if(definedVarRef.isVersion()) {
            newVar = ((VariableVersion) definedVar).getVersionOf().createVersion();
         } else {
            throw new RuntimeException("Error! Variable is not versioned or intermediate " + definedVar.toString(program));
         }
         definedToNewVar.put(definedVarRef, newVar.getRef());
         //getLog().append("Defined in loop: " + definedVarRef.getFullName() + " -> " + newVar.getRef().getFullName());
      }
      return definedToNewVar;
   }

   /**
    * Copy labels for all blocks to be unrolled. The new copies are named from the original name plus an integer suffix.
    *
    * @param unrollBlocks The blocks being copied
    * @return A map from each block label (to be unrolled) to the new copied labels
    */
   private static Map<LabelRef, LabelRef> copyBlockLabels(BlockSet unrollBlocks, Program program) {
      LinkedHashMap<LabelRef, LabelRef> blockToNewBlock = new LinkedHashMap<>();
      for(ControlFlowBlock block : unrollBlocks.getBlocks(program.getGraph())) {
         Scope blockScope = program.getScope().getScope(block.getScope());
         // Find the serial number
         int unrollSerial = 1;
         String localName = block.getLabel().getLocalName();
         int serialPos = localName.lastIndexOf("_");
         if(serialPos >= 0) {
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
    * Copy all blocks being unrolled in the control flow graph
    * - Unroll Statements (copy all statements, replace symbols properly (with the new versions / the versions assigned in the existing loop)
    * - Rewrite transitions in both original and copy according to the strategy
    */
   private void unrollBlocks() {
      for(ControlFlowBlock origBlock : unrollBlocks.getBlocks(program.getGraph())) {
         // Create the new block
         LabelRef newBlockLabel = blocksOriginalToCopied.get(origBlock.getLabel());
         ControlFlowBlock newBlock = new ControlFlowBlock(newBlockLabel, origBlock.getScope());
         program.getGraph().addBlock(newBlock);
         for(Statement origStatement : origBlock.getStatements()) {
            Statement newStatement = unrollStatement(origStatement, origBlock.getLabel());
            newBlock.addStatement(newStatement);
            if(origStatement instanceof StatementConditionalJump) {
               // Update conditional successors
               origBlock.setConditionalSuccessor(((StatementConditionalJump) origStatement).getDestination());
               newBlock.setConditionalSuccessor(((StatementConditionalJump) newStatement).getDestination());
            } else if(newStatement instanceof StatementCall) {
               // Update call successors
               newBlock.setCallSuccessor(origBlock.getCallSuccessor());
            }
         }

         // Set default successor for both new & original blocks
         LabelRef origSuccessor = origBlock.getDefaultSuccessor();
         if(isInternal(origSuccessor)) {
            // Default Successor is inside copied blocks - Use strategy to find default successors
            UnrollStrategy.TransitionHandling handling = strategy.getInternalStrategy(origBlock.getLabel(), origSuccessor);
            if(UnrollStrategy.TransitionHandling.TO_COPY.equals(handling)) {
               // The transition in both original and copy should go to the copy
               LabelRef newSuccessor = blocksOriginalToCopied.get(origSuccessor);
               origBlock.setDefaultSuccessor(newSuccessor);
               newBlock.setDefaultSuccessor(newSuccessor);
            } else if(UnrollStrategy.TransitionHandling.TO_ORIGINAL.equals(handling)) {
               // The transition in both original and copy should go to the original
               newBlock.setDefaultSuccessor(origSuccessor);
            } else if(UnrollStrategy.TransitionHandling.TO_BOTH.equals(handling)) {
               // The transition in the new copy should go between the newly copied blocks
               LabelRef newSuccessor = blocksOriginalToCopied.get(origSuccessor);
               newBlock.setDefaultSuccessor(newSuccessor);
            }
         } else {
            // Default Successor is outside copied blocks
            // Set the same successor for the copied blocks as in the original
            newBlock.setDefaultSuccessor(origSuccessor);
            // Update the PHI blocks of the external default successor to also get values from the copied PHI block
            patchSuccessorBlockPhi(origSuccessor, origBlock.getLabel(), newBlockLabel);
         }

         // Examine whether conditional successor is external
         LabelRef origConditionalSuccessor = origBlock.getConditionalSuccessor();
         if(origConditionalSuccessor != null) {
            if(!isInternal(origConditionalSuccessor)) {
               // Update the PHI blocks of the external conditional successor to also get values from the copied PHI block
               patchSuccessorBlockPhi(origConditionalSuccessor, origBlock.getLabel(), newBlockLabel);
            }
         }

      }
   }

   /**
    * Determine if a block is one of the blovks being copied (original or copy)
    *
    * @param block The block to examine
    * @return true if the block is one of the blocks being copied
    */
   private boolean isInternal(LabelRef block) {
      return unrollBlocks.contains(block) || blocksOriginalToCopied.values().contains(block);

   }

   /**
    * Patch the PHI-block of an external successor block. Ensures that the PHI-block also receives data from the new coped block.
    *
    * @param successor The successor block's label
    * @param origBlock The label of the original block
    * @param newBlock The label of the newly created copy
    */
   private void patchSuccessorBlockPhi(LabelRef successor, LabelRef origBlock, LabelRef newBlock) {
      ControlFlowBlock successorBlock = program.getGraph().getBlock(successor);
      StatementPhiBlock successorPhiBlock = successorBlock.getPhiBlock();
      for(StatementPhiBlock.PhiVariable phiVariable : successorPhiBlock.getPhiVariables()) {
         List<StatementPhiBlock.PhiRValue> phiRValues = phiVariable.getValues();
         ListIterator<StatementPhiBlock.PhiRValue> phiRValuesIt = phiRValues.listIterator();
         while(phiRValuesIt.hasNext()) {
            StatementPhiBlock.PhiRValue phiRValue = phiRValuesIt.next();
            if(phiRValue.getPredecessor().equals(origBlock)) {
               RValue newRValue = valueToNew(phiRValue.getrValue(), varsOriginalToCopied);
               phiRValuesIt.add(new StatementPhiBlock.PhiRValue(newBlock, newRValue));
            }
         }
      }
   }

   /**
    * Unroll a single statement inside a block.
    * Copy the statement, replace symbols properly (with the new versions if needed).
    * This includes handling any PHI-statements and successors
    *
    * @param origStatement The statement to unroll
    * @return The copied & unrolled statement
    */
   private Statement unrollStatement(Statement origStatement, LabelRef origBlock) {
      if(origStatement instanceof StatementPhiBlock) {
         return unrollStatementPhi((StatementPhiBlock) origStatement, origBlock);
      } else if(origStatement instanceof StatementAssignment) {
         StatementAssignment assignment = (StatementAssignment) origStatement;
         return new StatementAssignment(
               (LValue) valueToNew(assignment.getlValue(), varsOriginalToCopied),
               valueToNew(assignment.getrValue1(), varsOriginalToCopied),
               assignment.getOperator(),
               valueToNew(assignment.getrValue2(), varsOriginalToCopied),
               assignment.getSource(),
               Comment.NO_COMMENTS
         );
      } else if(origStatement instanceof StatementConditionalJump) {
         return unrollStatementConditionalJump((StatementConditionalJump) origStatement, origBlock);
      } else if(origStatement instanceof StatementCall) {
         StatementCall call = (StatementCall) origStatement;
         StatementCall newCall = new StatementCall(null, call.getProcedureName(), null, call.getSource(), Comment.NO_COMMENTS);
         newCall.setProcedure(call.getProcedure());
         return newCall;
      } else {
         throw new RuntimeException("Statement not handled by unroll " + origStatement);
      }
   }

   /**
    * Create a copy of a conditional jump statement. Also updates the original  conditional jump if specified by the strategy.
    *
    * @param origConditional The original conditional jump
    * @param origBlock The block containing the original PHI statement
    * @return The new copied conditional jump statement.
    */
   private Statement unrollStatementConditionalJump(StatementConditionalJump origConditional, LabelRef origBlock) {
      // First copy the statement
      StatementConditionalJump newConditional = new StatementConditionalJump(
            valueToNew(origConditional.getrValue1(), varsOriginalToCopied),
            origConditional.getOperator(),
            valueToNew(origConditional.getrValue2(), varsOriginalToCopied),
            origConditional.getDestination(),
            origConditional.getSource(),
            Comment.NO_COMMENTS
      );
      newConditional.setDeclaredUnroll(origConditional.isDeclaredUnroll());
      // Then make sure the destination is correct in both the original and copy
      LabelRef origSuccessor = origConditional.getDestination();
      if(isInternal(origSuccessor)) {
         // Successor is inside the copied blocks!
         UnrollStrategy.TransitionHandling handling = strategy.getInternalStrategy(origBlock, origSuccessor);
         if(UnrollStrategy.TransitionHandling.TO_COPY.equals(handling)) {
            // The transition in both original and copy should go to the copy
            LabelRef newSuccessor = blocksOriginalToCopied.get(origSuccessor);
            origConditional.setDestination(newSuccessor);
            newConditional.setDestination(newSuccessor);
         } else if(UnrollStrategy.TransitionHandling.TO_ORIGINAL.equals(handling)) {
            // The transition in both original and copy should go to the original
            // No action necessary since both original & copy already point to the original successor
         } else if(UnrollStrategy.TransitionHandling.TO_BOTH.equals(handling)) {
            // The transition in the new copy should go between the newly copied blocks
            LabelRef newSuccessor = blocksOriginalToCopied.get(origSuccessor);
            newConditional.setDestination(newSuccessor);
         }
      } else {
         // Successor is outside the copied blocks!
         // No action necessary since both original & copy already point to the successor
      }
      return newConditional;
   }

   /**
    * Create a copy of a PHI-statement. Also updates the original PHI-statement if specified by the strategy.
    *
    * @param origPhiBlock The original PHI statement
    * @param origBlock The block containing the original PHI statement
    * @return The new copied PH statement.
    */
   private Statement unrollStatementPhi(StatementPhiBlock origPhiBlock, LabelRef origBlock) {
      StatementPhiBlock newPhiBlock = new StatementPhiBlock(Comment.NO_COMMENTS);
      for(StatementPhiBlock.PhiVariable origPhiVariable : origPhiBlock.getPhiVariables()) {
         VariableRef origPhiVar = origPhiVariable.getVariable();
         VariableRef newPhiVar = varsOriginalToCopied.get(origPhiVar);
         StatementPhiBlock.PhiVariable newPhiVariable = newPhiBlock.addPhiVariable(newPhiVar);
         List<StatementPhiBlock.PhiRValue> origPhiRValues = origPhiVariable.getValues();
         ListIterator<StatementPhiBlock.PhiRValue> origPhiRValuesIt = origPhiRValues.listIterator();
         while(origPhiRValuesIt.hasNext()) {
            StatementPhiBlock.PhiRValue origPhiRValue = origPhiRValuesIt.next();
            LabelRef predecessor = origPhiRValue.getPredecessor();
            if(isInternal(predecessor)) {
               // Predecessor is inside the loop
               UnrollStrategy.TransitionHandling handling = strategy.getInternalStrategy(predecessor, origBlock);
               if(UnrollStrategy.TransitionHandling.TO_COPY.equals(handling)) {
                  // The transition in both original and copy should go to the copy
                  // - First create new entry from the new predecessor block
                  RValue rValueNew = valueToNew(origPhiRValue.getrValue(), varsOriginalToCopied);
                  newPhiVariable.setrValue(blocksOriginalToCopied.get(predecessor), rValueNew);
                  // - Then an entry from the existing predecessor block
                  RValue rValue = valueToOrig(origPhiRValue.getrValue());
                  newPhiVariable.setrValue(predecessor, rValue);
                  // Finally remove the phi entry into the original block (since both will hit the new block)
                  origPhiRValuesIt.remove();
               } else if(UnrollStrategy.TransitionHandling.TO_ORIGINAL.equals(handling)) {
                  // The transition in both original and copy should go to the original
                  // Create new entry in the original block from the new predecessor block
                  RValue rValueNew = valueToNew(origPhiRValue.getrValue(), varsOriginalToCopied);
                  origPhiRValuesIt.add(new StatementPhiBlock.PhiRValue(blocksOriginalToCopied.get(predecessor), rValueNew));
               } else if(UnrollStrategy.TransitionHandling.TO_BOTH.equals(handling)) {
                  // The transition in the new copy should go between the newly copied blocks
                  RValue rValueNew = valueToNew(origPhiRValue.getrValue(), varsOriginalToCopied);
                  newPhiVariable.setrValue(blocksOriginalToCopied.get(predecessor), rValueNew);
               }
            } else {
               // Predecessor is outside loop
               UnrollStrategy.TransitionHandling handling = strategy.getEntryStrategy(predecessor, origBlock);
               if(UnrollStrategy.TransitionHandling.TO_COPY.equals(handling)) {
                  // The transition should go to the new copy
                  newPhiVariable.setrValue(predecessor, origPhiRValue.getrValue());
                  // Remove the phi entry into the original block since only the new block is hit
                  origPhiRValuesIt.remove();
                  // Update the successor in the predecessor block to point to the new copy
                  ControlFlowBlock predecessorBlock = program.getGraph().getBlock(predecessor);
                  LabelRef newBlock = blocksOriginalToCopied.get(origBlock);
                  if(origBlock.equals(predecessorBlock.getDefaultSuccessor())) {
                     predecessorBlock.setDefaultSuccessor(newBlock);
                  } else if(origBlock.equals(predecessorBlock.getConditionalSuccessor())) {
                     predecessorBlock.setConditionalSuccessor(newBlock);
                     for(Statement predecessorStatement : predecessorBlock.getStatements()) {
                        if(predecessorStatement instanceof StatementConditionalJump) {
                           ((StatementConditionalJump) predecessorStatement).setDestination(newBlock);
                        }
                     }
                  }
               } else if(UnrollStrategy.TransitionHandling.TO_ORIGINAL.equals(handling)) {
                  // The transition should go to the original
                  // Do nothing!
               }
            }
         }
      }
      return newPhiBlock;
   }

   /**
    * Any variable references inside the value points to variables in the new copied version of the copied blocks
    * Creates a copy of the passed value object (to avoid that two parts of the model points to the same object).
    *
    * @param rValue The rValue to update
    * @param definedToNewVar Map from variables defined in the original loop to the variables in the new unrolled "rest" loop
    * @return A copy of the RValue with all relevant variable references updated
    */
   private static RValue valueToNew(RValue rValue, Map<VariableRef, VariableRef> definedToNewVar) {
      if(rValue == null) return null;
      RValue rValueCopy = valueToOrig(rValue);
      ProgramValue.GenericValue genericValue = new ProgramValue.GenericValue(rValueCopy);
      ProgramValueIterator.execute(genericValue, (programValue, currentStmt, stmtIt, currentBlock) -> {
         Value rVal = programValue.get();
         if(rVal instanceof VariableRef) {
            if(definedToNewVar.get(rVal) != null) {
               programValue.set(definedToNewVar.get(rVal));
            }
         }
      }, null, null, null);
      return (RValue) genericValue.get();
   }

   /**
    * Any variable references inside the value points to variables in the original version of the copied blocks
    * Creates a copy of the passed value object (to avoid that two parts of the model points to the same object).
    *
    * @param rValue The value to copy
    * @return An exact copy of the value
    */
   private static RValue valueToOrig(RValue rValue) {
      if(rValue == null) return null;
      ProgramValue.GenericValue genericValue = new ProgramValue.GenericValue(rValue);
      ProgramValueIterator.execute(genericValue, (programValue, currentStmt, stmtIt, currentBlock) -> {
         Value rVal = programValue.get();
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
      return (RValue) genericValue.get();
   }

   /** Strategy for handling transitions into blocks that have been copied */
   public interface UnrollStrategy {

      /** Specifies where a transition destination should be after the unrolling. */
      enum TransitionHandling {
         /** The transition should go the original block */
         TO_ORIGINAL,
         /** The transition should go the copied block */
         TO_COPY,
         /** The transition should be copied itself (only legal for transitions where both blocks have been copied) */
         TO_BOTH
      }

      /**
       * Find out how to handle a transition going into the blocks being copied.
       *
       * @param from The predecessor block of the transition (outside the copied blocks)
       * @param to The (original) destination block of the transition (inside the copied blocks).
       * @return Whether the transition should hit the original or the copy in the modified graph.
       */
      TransitionHandling getEntryStrategy(LabelRef from, LabelRef to);

      /**
       * Find out how to handle a transition between two blocks being copied.
       *
       * @param from The predecessor block of the transition (inside the copied blocks)
       * @param to The (original) destination block of the transition (inside the copied blocks).
       * @return Whether the transition should be copied itself, always go to the original or always to the copy.
       */
      TransitionHandling getInternalStrategy(LabelRef from, LabelRef to);

   }

   /**
    * Find all transitions where the flow of control leaves a block set
    *
    * @param blockSet The loop to examine
    * @param graph The control flow graph
    * @return All transitions leaving the block set
    */
   private static List<SuccessorTransition> getSuccessorTransitions(BlockSet blockSet, ControlFlowGraph graph) {
      List<SuccessorTransition> successorTransitions = new ArrayList<>();
      for(ControlFlowBlock block : blockSet.getBlocks(graph)) {
         if(block.getDefaultSuccessor() != null && !blockSet.getBlocks().contains(block.getDefaultSuccessor())) {
            // Default successor is outside
            successorTransitions.add(new SuccessorTransition(block.getDefaultSuccessor(), block.getLabel()));
         }
         if(block.getConditionalSuccessor() != null && !blockSet.getBlocks().contains(block.getConditionalSuccessor())) {
            // Conditional successor is outside
            successorTransitions.add(new SuccessorTransition(block.getConditionalSuccessor(), block.getLabel()));
         }
      }
      return successorTransitions;
   }

   /** Information about a transition leaving a block set - ie. a transition from a block inside the set to a successor block outside. */
   public static class SuccessorTransition {
      /** A block that is the successor to a block in the set. */
      LabelRef successor;
      /** The block inside the set that is the predecessor of the successor block. */
      LabelRef predecessor;

      SuccessorTransition(LabelRef successor, LabelRef predecessor) {
         this.successor = successor;
         this.predecessor = predecessor;
      }
   }

   /**
    * Determine whether a variable is referenced outside a block set
    *
    * @param variableRef The variable
    * @param blockSet The block set
    * @param program The program
    * @return true if the variable is ever referenced outside the block set
    */
   private static boolean isReferencedOutside(VariableRef variableRef, BlockSet blockSet, Program program) {
      boolean referencedOutside = false;
      VariableReferenceInfos variableReferenceInfos = program.getVariableReferenceInfos();
      StatementInfos statementInfos = program.getStatementInfos();
      Collection<Integer> varRefStatements = variableReferenceInfos.getVarRefStatements(variableRef);
      for(Integer varRefStatement : varRefStatements) {
         ControlFlowBlock refBlock = statementInfos.getBlock(varRefStatement);
         if(!blockSet.getBlocks().contains(refBlock.getLabel())) {
            referencedOutside = true;
            break;
         }
      }
      return referencedOutside;
   }

   /**
    * Get all variables defined inside the blocks
    *
    * @param blockSet The blocks to be unrolled
    * @param program The program
    * @return All variables defined inside the blocks to be unrolled
    */
   private static List<VariableRef> getVarsDefinedIn(BlockSet blockSet, Program program) {
      VariableReferenceInfos variableReferenceInfos = program.getVariableReferenceInfos();
      List<VariableRef> definedInBlocks = new ArrayList<>();
      for(ControlFlowBlock block : blockSet.getBlocks(program.getGraph())) {
         for(Statement statement : block.getStatements()) {
            Collection<VariableRef> definedVars = variableReferenceInfos.getDefinedVars(statement);
            definedInBlocks.addAll(definedVars);
         }
      }
      return definedInBlocks;
   }

}
