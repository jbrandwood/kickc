package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementConditionalJump;
import dk.camelot64.kickc.model.statements.StatementPhiBlock;
import dk.camelot64.kickc.model.symbols.Label;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.symbols.VariableVersion;
import dk.camelot64.kickc.model.values.LabelRef;
import dk.camelot64.kickc.model.values.RValue;
import dk.camelot64.kickc.model.values.VariableRef;

import java.util.*;

/** Unroll Loops declared as inline. */
public class Pass2LoopUnroll extends Pass2SsaOptimization {

   public Pass2LoopUnroll(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      // Look for loops to unroll
      NaturalLoopSet loops = getProgram().getLoopSet();
      List<NaturalLoop> unrollLoopCandidates = findUnrollLoopCandidates(getProgram(), loops);
      // Is there any unrolling to do?
      if(unrollLoopCandidates.isEmpty()) {
         return false;
      }
      // Choose the candidate loop with the fewest blocks (and if several have the same number of blocks the first one encountered)
      NaturalLoop unrollLoop = chooseUnrollLoop(unrollLoopCandidates);
      getLog().append("Unrolling loop " + unrollLoop);

      // Unroll the first iteration of the loop

      // 0. Unroll Symbols
      // - Create new versions of all symbols assigned inside the loop
      Map<VariableRef, VariableRef> definedToNewVar = new LinkedHashMap<>();
      for(VariableRef definedVarRef : getVarsDefinedInLoop(getProgram(), unrollLoop)) {
         Variable definedVar = getScope().getVariable(definedVarRef);
         Variable newVar;
         if(definedVarRef.isIntermediate()) {
            newVar = definedVar.getScope().addVariableIntermediate();
         } else if(definedVarRef.isVersion()) {
            newVar = ((VariableVersion) definedVar).getVersionOf().createVersion();
         } else {
            throw new RuntimeException("Error! Variable is not versioned or intermediate " + definedVar.toString(getProgram()));
         }
         definedToNewVar.put(definedVarRef, newVar.getRef());
         getLog().append("Defined in loop: " + definedVarRef.getFullName() + " -> " + newVar.getRef().getFullName());
      }

      // 1. Copy all loop blocks to create the "rest of the loop" and modifying the existing loop to only be the first iteration)
      //  - Unroll Statements (copy all statements, replace symbols properly (with the new versions / the versions assigned in the existing loop)
      //    - Includes unrolling PHI-statements properly
      //  - Unroll Successors (loop-exit successors should point to the same exit, loop-internal successors should point to the new loop-internal block)
      for(ControlFlowBlock block : unrollLoop.getBlocks(getGraph())) {
         // Find the serial number
         int unrollSerial = 1;
         String unrollLabelName = block.getLabel() + "_" + unrollSerial;
         while(getScope().getLabel(unrollLabelName) != null) {
            unrollSerial++;
         }
         // Create a label
         Label unrollLabel = getScope().getScope(block.getScope()).addLabel(unrollLabelName);
         // Create the new block
         ControlFlowBlock unrollBlock = new ControlFlowBlock(unrollLabel.getRef(), block.getScope());
         getProgram().getGraph().addBlock(unrollBlock);
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementPhiBlock) {
               StatementPhiBlock phiBlock = (StatementPhiBlock) statement;
               StatementPhiBlock unrollPhiBlock = new StatementPhiBlock();
               for(StatementPhiBlock.PhiVariable phiVariable : phiBlock.getPhiVariables()) {
                  VariableRef phiVar = phiVariable.getVariable();
                  VariableRef newVar = definedToNewVar.get(phiVar);
                  StatementPhiBlock.PhiVariable unrollPhiVariable = unrollPhiBlock.addPhiVariable(newVar);
                  for(StatementPhiBlock.PhiRValue phiRValue : phiVariable.getValues()) {
                        /* FIX */
                     LabelRef predecessor = phiRValue.getPredecessor();
                        /* FIX */
                     RValue rValue = phiRValue.getrValue();
                     unrollPhiVariable.setrValue(predecessor, rValue);
                  }
               }
            } else {
               throw new RuntimeException("Statement not handled by unroll " + statement);
            }
         }
      }

      // Patch the "old loop" to only contain the first iteration
      //  - All successors in the old loop to the loop head should point to the new loop head instead.
      //  - Remove phi-variables in the old head from looping. (as this predecessor now no longer exists)
      //  - Remove the "unroll" directive on the condition in the old loop (as it is already unrolled).

      return false;

   }

   /**
    * Choose which loop to unroll first from a candidate set.
    * The smallest loop (fewest control flow blocks) is chosen.
    * If multiple loops have the same size the first one is chosen.
    *
    * @param unrollLoopCandidates All loops that are decalred to be unrolled
    * @return The loop to unroll first.
    */
   private NaturalLoop chooseUnrollLoop(List<NaturalLoop> unrollLoopCandidates) {
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
    * @param loops All loops identified in the program
    * @return All loops declared to be unrolled
    */
   static List<NaturalLoop> findUnrollLoopCandidates(Program program, NaturalLoopSet loops) {
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
    * @param program The program
    * @param loop The loop
    * @return All variables defined inside the blocks of the loop
    */
   static List<VariableRef> getVarsDefinedInLoop(Program program, NaturalLoop loop) {
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

   /** Information about a block successing a loop - ie. a place where the flow of control leaves a loop. */
   public static class LoopSuccessorBlock {
      /** A block that is the sucessor to a block inside the loop. */
      LabelRef sucessor;
      /** The block inside the loop that is the predecessor of the loop sucessor block. */
      LabelRef predecessor;

      public LoopSuccessorBlock(LabelRef sucessor, LabelRef predecessor) {
         this.sucessor = sucessor;
         this.predecessor = predecessor;
      }
   }

   /**
    * Find all transitions where the flow of control leaves a loop
    * @param loop The loop to examine
    * @param  graph The control flow graph
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


}
