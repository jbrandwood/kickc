package dk.camelot64.kickc.icl;

import java.util.*;

/** Pass that culls empty control flow blocks from the program */
public class Pass2CullEmptyBlocks extends Pass2SsaOptimization {

   public Pass2CullEmptyBlocks(ControlFlowGraph graph, Scope scope) {
      super(graph, scope);
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
      for (ControlFlowBlock removeBlock : remove) {
         ControlFlowBlock successor = getGraph().getDefaultSuccessor(removeBlock);
         for (ControlFlowBlock predecessor : getGraph().getPredecessors(removeBlock)) {
            replace.put(removeBlock.getLabel(), predecessor.getLabel());
            if (removeBlock.getLabel().equals(predecessor.getDefaultSuccessor())) {
               predecessor.setDefaultSuccessor(successor.getLabel());
            }
            if (removeBlock.getLabel().equals(predecessor.getConditionalSuccessor())) {
               predecessor.setConditionalSuccessor(successor.getLabel());
            }
            if (removeBlock.getLabel().equals(predecessor.getCallSuccessor())) {
               predecessor.setCallSuccessor(successor.getLabel());
            }
         }
         getGraph().getAllBlocks().remove(removeBlock);
         getSymbols().remove(removeBlock.getLabel());
         System.out.println("Culled Empty Block " + removeBlock.getLabel());
      }
      replaceLabels(replace);
      return remove.size()>0;
   }

}
