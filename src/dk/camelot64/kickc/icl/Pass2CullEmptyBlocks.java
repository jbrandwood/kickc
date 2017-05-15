package dk.camelot64.kickc.icl;

import java.util.*;

/** Pass that culls empty control flow blocks from the program */
public class Pass2CullEmptyBlocks extends Pass2Optimization {

   public Pass2CullEmptyBlocks(ControlFlowGraph graph, SymbolTable symbolTable) {
      super(graph, symbolTable);
   }

   @Override
   public boolean optimize() {
      List<ControlFlowBlock> remove = new ArrayList<>();
      Map<Label, Label> replace = new HashMap<>();
      for (ControlFlowBlock block : getGraph().getAllBlocks()) {
         if (block.getStatements().isEmpty() && block.getLabel().isIntermediate()) {
            remove.add(block);
         }
      }
      for (ControlFlowBlock block : remove) {
         ControlFlowBlock successor = block.getDefaultSuccessor();
         for (ControlFlowBlock predecessor : block.getPredecessors()) {
            replace.put(block.getLabel(), predecessor.getLabel());
            if (block.equals(predecessor.getDefaultSuccessor())) {
               predecessor.setDefaultSuccessor(successor);
               if (successor != null) {
                  successor.addPredecessor(predecessor);
               }
            }
            if (block.equals(predecessor.getConditionalSuccessor())) {
               predecessor.setConditionalSuccessor(successor);
               if (successor != null) {
                  successor.addPredecessor(predecessor);
               }
            }
         }
         if (successor != null && block.getLabel().isIntermediate()) {
            successor.removePredecessor(block);
         }
         getGraph().getAllBlocks().remove(block);
         getSymbols().remove(block.getLabel());
         System.out.println("Culled Empty Block " + block.getLabel());
      }
      replaceLabels(replace);
      return remove.size()>0;
   }

}
