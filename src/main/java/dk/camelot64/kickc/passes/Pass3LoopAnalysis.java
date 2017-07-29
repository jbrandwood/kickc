package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.CompileLog;
import dk.camelot64.kickc.icl.*;

import java.util.*;

/**
 * Finds loops and nested loops in the control flow graph.
 * Uses the dominators of the graph to find loops.
 * <p>
 * See http://www.cs.colostate.edu/~cs553/ClassNotes/lecture09-control-dominators.ppt.pdf
 */
public class Pass3LoopAnalysis {

   private Program program;
   private CompileLog log;

   public Pass3LoopAnalysis(Program program, CompileLog log) {
      this.program = program;
      this.log = log;
   }

   public Program getProgram() {
      return program;
   }

   public CompileLog getLog() {
      return log;
   }

   /**
    * Finds loops and nested loops in the control flow graph.
    * Uses the dominators of the graph to find loops.
    * <p>
    * See http://www.cs.colostate.edu/~cs553/ClassNotes/lecture09-control-dominators.ppt.pdf
    */
   public void findLoops() {
      DominatorsGraph dominators = program.getGraph().getDominators();
      Collection<ControlFlowBlock> blocks = program.getGraph().getAllBlocks();

      // Look through graph for natural loop back edges
      NaturalLoopSet loopSet = new NaturalLoopSet();
      for (ControlFlowBlock block : blocks) {
         DominatorsBlock blockDominators = dominators.getDominators(block.getLabel());
         for (LabelRef successor : block.getSuccessors()) {
            if (blockDominators.contains(successor)) {
               // Found a loop back edge!
               NaturalLoop loop = new NaturalLoop(successor, block.getLabel());
               log.append("Found back edge: "+loop.toString());
               loopSet.addLoop(loop);
            }
         }
      }

      // Find all blocks for each loop
      for (NaturalLoop loop : loopSet.getLoops()) {
         Deque<LabelRef> todo = new ArrayDeque<>();
         Set<LabelRef> loopBlocks = new LinkedHashSet<>();
         todo.addAll(loop.getTails());
         while(!todo.isEmpty()) {
            LabelRef block = todo.pop();
            loopBlocks.add(block);
            if(block.equals(loop.getHead())) {
               continue;
            }
            ControlFlowBlock controlFlowBlock = program.getGraph().getBlock(block);
            List<ControlFlowBlock> predecessors = program.getGraph().getPredecessors(controlFlowBlock);
            for (ControlFlowBlock predecessor : predecessors) {
               if(!loopBlocks.contains(predecessor.getLabel()) && !todo.contains(predecessor.getLabel())) {
                  todo.add(predecessor.getLabel());
               }
            }
         }
         loop.setBlocks(loopBlocks);
         log.append("Populated: "+loop.toString());
      }

      // Coalesce loops that are neither nested, nor disjoint
      for (NaturalLoop loop : loopSet.getLoops()) {
         Set<NaturalLoop> headLoops = loopSet.getLoopsFromHead(loop.getHead());
         for (NaturalLoop other : headLoops) {
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
               log.append("Coalesced: "+loop.toString()) ;
            }
         }
      }

      program.getGraph().setLoops(loopSet);
   }


}
