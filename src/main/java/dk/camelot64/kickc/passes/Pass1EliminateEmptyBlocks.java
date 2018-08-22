package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.CompileLog;
import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.symbols.Label;
import dk.camelot64.kickc.model.symbols.Symbol;
import dk.camelot64.kickc.model.values.LabelRef;
import dk.camelot64.kickc.model.values.SymbolRef;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

/**
 * Eliminate empty blocks in pass 1 (before creating SSA)
 */
public class Pass1EliminateEmptyBlocks extends Pass1Base {

   public Pass1EliminateEmptyBlocks(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      CompileLog log = getLog();
      ControlFlowGraph graph = getProgram().getGraph();
      Collection<ControlFlowBlock> blocks = graph.getAllBlocks();
      List<LabelRef> removeList = new ArrayList<>();
      for(ControlFlowBlock block : blocks) {
         if(block.getLabel().getFullName().equals(SymbolRef.END_BLOCK_NAME)) {
            continue;
         } else if(block.getLabel().getFullName().equals(SymbolRef.BEGIN_BLOCK_NAME)) {
            continue;
         }
         if(block.getStatements().isEmpty()) {
            List<ControlFlowBlock> predecessors = graph.getPredecessors(block);
            boolean remove = true;
            for(ControlFlowBlock predecessor : predecessors) {
               if(predecessor.getDefaultSuccessor().equals(block.getLabel())) {
                  predecessor.setDefaultSuccessor(block.getDefaultSuccessor());
               } else {
                  remove = false;
               }
            }
            if(remove) {
               removeList.add(block.getLabel());
            }
         }
      }
      boolean modified = false;
      for(LabelRef labelRef : removeList) {
         Symbol removeSymbol = getScope().getSymbol(labelRef);
         if(removeSymbol instanceof Label) {
            Label label = (Label) removeSymbol;
            graph.remove(labelRef);
            label.getScope().remove(label);
            if(log.isVerbosePass1CreateSsa()) {
               log.append("Removing empty block " + labelRef);
            }
            modified = true;
         }
      }
      return modified;
   }

}
