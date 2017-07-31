package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.CompileLog;
import dk.camelot64.kickc.icl.*;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

/**
 * Eliminate empty blocks in pass 1 (before creating SSA)
 */
public class Pass1EliminateEmptyBlocks {

   private Program program;

   public Pass1EliminateEmptyBlocks(Program program) {
      this.program = program;
   }

   public boolean eliminate() {
      CompileLog log = program.getLog();
      ControlFlowGraph graph = program.getGraph();
      Collection<ControlFlowBlock> blocks = graph.getAllBlocks();
      List<LabelRef> removeList = new ArrayList<>();
      for (ControlFlowBlock block : blocks) {
         if(block.getLabel().getFullName().equals("@END")) {
            continue;
         }
         if (block.getStatements().isEmpty()) {
            List<ControlFlowBlock> predecessors = graph.getPredecessors(block);
            boolean remove = true;
            for (ControlFlowBlock predecessor : predecessors) {
               if(predecessor.getDefaultSuccessor().equals(block.getLabel())) {
                  predecessor.setDefaultSuccessor(block.getDefaultSuccessor());
               } else {
                  remove = false;
               }
            }
            if (remove) {
               removeList.add(block.getLabel());
            }
         }
      }
      for (LabelRef labelRef : removeList) {
         graph.remove(labelRef);
         Label label = program.getScope().getLabel(labelRef);
         label.getScope().remove(label);
         log.append("Removing empty block "+labelRef);
      }
      return removeList.size()>0;
   }

}
