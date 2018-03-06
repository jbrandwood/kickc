package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.values.LabelRef;

import java.util.ArrayList;
import java.util.List;

/** Finds the dominators for the control flow graph. */
public class Pass3DominatorsAnalysis extends Pass2Base {

   public Pass3DominatorsAnalysis(Program program) {
      super(program);
   }

   /**
    * Analyse the control flow graph to find dominators for all blocks.
    * <p>
    * Definition: d dom i if all paths from entry to node i include d
    * <p>
    * See http://www.cs.colostate.edu/~cs553/ClassNotes/lecture09-control-dominators.ppt.pdf
    *
    * @return The graph dominators
    */
   public void findDominators() {
      DominatorsGraph dominatorsGraph = new DominatorsGraph();

      // Initialize dominators: Dom[first]={first}, Dom[block]={all}
      LabelRef firstBlock = getGraph().getFirstBlock().getLabel();
      DominatorsBlock firstDominators = dominatorsGraph.addDominators(firstBlock);
      firstDominators.add(firstBlock);
      List<LabelRef> allBlocks = new ArrayList<>();
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         allBlocks.add(block.getLabel());
      }
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         if(!block.getLabel().equals(firstBlock)) {
            DominatorsBlock dominatorsBlock = dominatorsGraph.addDominators(block.getLabel());
            dominatorsBlock.addAll(allBlocks);
         }
      }

      // Iteratively refine dominators until they do not change
      // For all nodes:
      // Dom[n] = {n} UNION ( INTERSECT Dom[p] for all p that are predecessors of n)
      boolean change = false;
      do {
         change = false;
         for(ControlFlowBlock block : getGraph().getAllBlocks()) {
            if(!block.getLabel().equals(firstBlock)) {
               List<ControlFlowBlock> predecessors = getGraph().getPredecessors(block);
               DominatorsBlock newDominators = new DominatorsBlock();
               newDominators.addAll(allBlocks);
               for(ControlFlowBlock predecessor : predecessors) {
                  DominatorsBlock predecessorDominators = dominatorsGraph.getDominators(predecessor.getLabel());
                  newDominators.intersect(predecessorDominators);
               }
               newDominators.add(block.getLabel());
               DominatorsBlock currentDominators = dominatorsGraph.getDominators(block.getLabel());
               if(!currentDominators.equals(newDominators)) {
                  change = true;
                  dominatorsGraph.setDominators(block.getLabel(), newDominators);
               }
            }
         }

      } while(change);
      getProgram().setDominators(dominatorsGraph);
   }


}
