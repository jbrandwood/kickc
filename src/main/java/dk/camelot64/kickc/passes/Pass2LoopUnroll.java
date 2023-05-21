package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.statements.*;
import dk.camelot64.kickc.model.values.*;
import dk.camelot64.kickc.passes.utils.Unroller;

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

      // The original loop becomes the first iteration - the new copy becomes "the rest of the loop"
      Unroller.UnrollStrategy loopUnrollStrategy = new Unroller.UnrollStrategy() {
         @Override
         public TransitionHandling getEntryStrategy(LabelRef from, LabelRef to) {
            return TransitionHandling.TO_ORIGINAL;
         }

         @Override
         public TransitionHandling getInternalStrategy(LabelRef from, LabelRef to) {
            if(unrollLoop.getHead().equals(to)) {
               return TransitionHandling.TO_COPY;
            } else {
               return TransitionHandling.TO_BOTH;
            }
         }
      };

      // Unroll the first iteration of the loop
      Unroller unroller = new Unroller(getProgram(), unrollLoop, loopUnrollStrategy);
      unroller.unroll();
      // Mark the original loop as unrolled
      markOriginalUnrolled(unrollLoop, getProgram());
      return true;
   }

   /**
    * Update the declaredUnroll / wasUnrolled information of the original loop blocks
    *
    * @param unroll The (original) blocks being unrolled
    */
   private static void markOriginalUnrolled(BlockSet unroll, Program program) {
      for(var block : unroll.getBlocks(program.getGraph())) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementConditionalJump) {
               //  - Remove the "unroll" directive on the condition in the old loop (as it is already unrolled).
               // TODO: Maybe only remove "unroll" from the conditional that represents the loop we are unrolling
               StatementConditionalJump conditionalJump = (StatementConditionalJump) statement;
               if(conditionalJump.isDeclaredUnroll()) {
                  // Mark is unrolled - to ensure it is removed before unrolling more
                  conditionalJump.setWasUnrolled(true);
                  // Remove unroll declaration - now only the "rest" of the loop needs unrolling
                  conditionalJump.setDeclaredUnroll(false);
               }
            }
         }
      }
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
   private static List<NaturalLoop> findUnrollLoops(Program program) {
      NaturalLoopSet loops = program.getLoopSet();
      List<NaturalLoop> unrollLoopCandidates = new ArrayList<>();
      for(var block : program.getGraph().getAllBlocks()) {
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

}
