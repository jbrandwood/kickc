package dk.camelot64.kickc.icl;

import java.util.*;

/** Pass that culls empty control flow blocks from the program */
public class PassCullEmptyBlocks {

   private SymbolTable symbolTable;
   private ControlFlowGraph graph;

   public PassCullEmptyBlocks(SymbolTable symbolTable, ControlFlowGraph controlFlowGraph) {
      this.symbolTable = symbolTable;
      this.graph = controlFlowGraph;
   }

   public void cull() {
      cullEmptyBlocks();
   }

   private void cullEmptyBlocks() {
      for (Iterator<ControlFlowBlock> iterator = graph.getAllBlocks().iterator(); iterator.hasNext(); ) {
         ControlFlowBlock block = iterator.next();
         if (block.getStatements().isEmpty()) {
            ControlFlowBlock successor = block.getDefaultSuccessor();
            for (ControlFlowBlock predecessor : block.getPredecessors()) {
               if (predecessor.getDefaultSuccessor().equals(block)) {
                  predecessor.setDefaultSuccessor(successor);
                  successor.addPredecessor(predecessor);
               }
               if (predecessor.getConditionalSuccessor().equals(block)) {
                  predecessor.setConditionalSuccessor(successor);
                  successor.addPredecessor(predecessor);
               }
            }
            successor.removePredecessor(block);
            iterator.remove();
            symbolTable.remove(block.getLabel());
         }
      }
   }

}
