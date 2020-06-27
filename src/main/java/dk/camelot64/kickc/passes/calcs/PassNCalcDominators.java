package dk.camelot64.kickc.passes.calcs;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.DominatorsBlock;
import dk.camelot64.kickc.model.DominatorsGraph;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.symbols.Scope;
import dk.camelot64.kickc.model.values.LabelRef;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.stream.Collectors;

/** Finds the dominators for the control flow graph. */
public class PassNCalcDominators extends PassNCalcBase<DominatorsGraph> {

   public PassNCalcDominators(Program program) {
      super(program);
   }


   /**
    * Analyse the control flow graph to find dominators for all blocks.
    * <p>
    * Definition: d dom i if all paths from entry to node i include d
    * <p>
    * See http://www.cs.colostate.edu/~cs553/ClassNotes/lecture09-control-dominators.ppt.pdf
    */
   @Override
   public DominatorsGraph calculate() {
      DominatorsGraph dominatorsGraph = new DominatorsGraph();

      Collection<Procedure> procedures = getScope().getAllProcedures(true);
      for(Procedure procedure : procedures) {
         calculateDominators(procedure, dominatorsGraph);
      }

      return dominatorsGraph;
   }

   private void calculateDominators(Scope scope, DominatorsGraph dominatorsGraph) {
      // Initialize dominators: Dom[first]={first}, Dom[block]={all}
      List<LabelRef> firstBlocks = new ArrayList<>();
      LabelRef firstBlock = ((Procedure) scope).getRef().getLabelRef();
      DominatorsBlock firstDominators = dominatorsGraph.addDominators(firstBlock);
      firstDominators.add(firstBlock);
      firstBlocks.add(firstBlock);
      List<LabelRef> procedureBlocks = getGraph().getScopeBlocks(scope.getRef()).stream().map(ControlFlowBlock::getLabel).collect(Collectors.toList());
      for(LabelRef procedureBlock : procedureBlocks) {
         if(!firstBlocks.contains(procedureBlock)) {
            DominatorsBlock dominatorsBlock = dominatorsGraph.addDominators(procedureBlock);
            dominatorsBlock.addAll(procedureBlocks);
         }
      }

      // Iteratively refine dominators until they do not change
      // For all nodes:
      // Dom[n] = {n} UNION ( INTERSECT Dom[p] for all p that are predecessors of n)
      boolean change;
      do {
         change = false;
         for(LabelRef procedureBlock : procedureBlocks) {
            if(!firstBlocks.contains(procedureBlock)) {
               ControlFlowBlock block = getGraph().getBlock(procedureBlock);
               List<ControlFlowBlock> predecessors = getGraph().getPredecessors(block);
               DominatorsBlock newDominators = new DominatorsBlock();
               newDominators.addAll(procedureBlocks);
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
   }


}
