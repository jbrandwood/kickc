package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.values.LabelRef;

import java.util.*;

/**
 * Finds loops and nested loops in the control flow graph.
 * Uses the dominators of the graph to find loops.
 * <p>
 * See http://www.cs.colostate.edu/~cs553/ClassNotes/lecture09-control-dominators.ppt.pdf
 */
public class PassNLoopAnalysis extends Pass2SsaOptimization {

   public PassNLoopAnalysis(Program program) {
      super(program);
   }


   /**
    * Finds loops and nested loops in the control flow graph.
    * Uses the dominators of the graph to find loops.
    * <p>
    * See http://www.cs.colostate.edu/~cs553/ClassNotes/lecture09-control-dominators.ppt.pdf
    */
   @Override
   public boolean step() {
      DominatorsGraph dominators = getProgram().getDominators();
      Collection<ControlFlowBlock> blocks = getGraph().getAllBlocks();

      // Look through graph for natural loop back edges
      NaturalLoopSet loopSet = new NaturalLoopSet();
      for(ControlFlowBlock block : blocks) {
         DominatorsBlock blockDominators = dominators.getDominators(block.getLabel());
         for(LabelRef successor : block.getSuccessors()) {
            if(blockDominators.contains(successor)) {
               // Found a loop back edge!
               NaturalLoop loop = new NaturalLoop(successor, block.getLabel());
               if(getLog().isVerboseLoopAnalysis()) {
                  getLog().append("Found back edge: " + loop.toString());
               }
               loopSet.addLoop(loop);
            }
         }
      }

      // Find all blocks for each loop
      for(NaturalLoop loop : loopSet.getLoops()) {
         Deque<LabelRef> todo = new ArrayDeque<>();
         Set<LabelRef> loopBlocks = new LinkedHashSet<>();
         todo.addAll(loop.getTails());
         while(!todo.isEmpty()) {
            LabelRef block = todo.pop();
            loopBlocks.add(block);
            if(block.equals(loop.getHead())) {
               continue;
            }
            ControlFlowBlock controlFlowBlock = getGraph().getBlock(block);
            List<ControlFlowBlock> predecessors = getGraph().getPredecessors(controlFlowBlock);
            for(ControlFlowBlock predecessor : predecessors) {
               if(!loopBlocks.contains(predecessor.getLabel()) && !todo.contains(predecessor.getLabel())) {
                  todo.add(predecessor.getLabel());
               }
            }
         }
         loop.setBlocks(loopBlocks);
         if(getLog().isVerboseLoopAnalysis()) {
            getLog().append("Populated: " + loop.toString());
         }
      }

      boolean coalesceMore = true;
      while(coalesceMore) {
         coalesceMore = coalesceLoops(loopSet);
      }
      getProgram().setLoopSet(loopSet);
      return false;
   }

   /**
    * Coalesce loops that are neither nested, nor disjoint
    * @param loopSet The set of loops
    * @return true if there might be more loops to coalesce - meaning the coalescer shoulbe be called again.
    *         false if no loops can be coalesced.
    */
   private boolean coalesceLoops(NaturalLoopSet loopSet) {
      for(NaturalLoop loop : loopSet.getLoops()) {
         Set<NaturalLoop> headLoops = loopSet.getLoopsFromHead(loop.getHead());
         for(NaturalLoop other : headLoops) {
            if(other.equals(loop)) {
               // Same loop - do not process
               continue;
            } else if(loop.nests(other) || other.nests(loop)) {
               // One of the loops nest the other loop
               continue;
            } else {
               // Two non-nested loops with a shared head - collect them to one loop
               loop.addTails(other.getTails());
               loop.addBlocks(other.getBlocks());
               loopSet.remove(other);
               if(getLog().isVerboseLoopAnalysis()) {
                  getLog().append("Coalesced: " + loop.toString());
               }
               return true;
            }
         }
      }
      return false;
   }


}
