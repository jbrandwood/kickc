package dk.camelot64.kickc.icl;

import dk.camelot64.kickc.CompileLog;

import java.util.*;

/** Pass that culls empty control flow blocks from the program */
public class Pass2CullEmptyBlocks extends Pass2SsaOptimization {

   public Pass2CullEmptyBlocks(ControlFlowGraph graph, Scope scope, CompileLog log) {
      super(graph, scope, log);
   }

   @Override
   public boolean optimize() {
      final List<ControlFlowBlock> remove = new ArrayList<>();
      for (ControlFlowBlock block : getGraph().getAllBlocks()) {
         if (block.getStatements().isEmpty() && block.getLabel().isIntermediate()) {
            remove.add(block);
         }
      }

      for (final ControlFlowBlock removeBlock : remove) {
         ControlFlowBlock successor = getGraph().getDefaultSuccessor(removeBlock);
         // Replace all jumps (default/conditional/call) to @removeBlock with a jump to the default successor
         final List<ControlFlowBlock> predecessors = getGraph().getPredecessors(removeBlock);
         for (ControlFlowBlock predecessor : predecessors) {
            Map<Label, Label> replace = new LinkedHashMap<>();
            replace.put(removeBlock.getLabel(), successor.getLabel());
            if (removeBlock.getLabel().equals(predecessor.getDefaultSuccessor())) {
               predecessor.setDefaultSuccessor(successor.getLabel());
            }
            if (removeBlock.getLabel().equals(predecessor.getConditionalSuccessor())) {
               predecessor.setConditionalSuccessor(successor.getLabel());
            }
            if (removeBlock.getLabel().equals(predecessor.getCallSuccessor())) {
               predecessor.setCallSuccessor(successor.getLabel());
            }
            replaceLabels(predecessor, replace);
         }
         // In all phi functions of a successor blocks make a copy of the phi assignment for each predecessor
         ControlFlowGraphBaseVisitor<Void> phiFixVisitor = new ControlFlowGraphBaseVisitor<Void>() {
            @Override
            public Void visitPhi(StatementPhi phi) {
               for (StatementPhi.PreviousSymbol previousSymbol : phi.getPreviousVersions()) {
                  if(previousSymbol.getBlock().equals(removeBlock.getLabel())) {
                     // Found a phi function referencing the remove block - add copies for each predecessor
                     RValue previousRValue = previousSymbol.getRValue();
                     for (ControlFlowBlock predecessor : predecessors) {
                        if(previousSymbol!=null) {
                           previousSymbol.setBlock(predecessor.getLabel());
                           previousSymbol = null;
                        } else {
                           phi.addPreviousVersion(predecessor.getLabel(), previousRValue);
                        }
                     }
                     break;
                  }
               }
               return null;
            }
         };
         phiFixVisitor.visitBlock(successor);
         getGraph().getAllBlocks().remove(removeBlock);
         getSymbols().remove(removeBlock.getLabel());
         log.append("Culled Empty Block " + removeBlock.getLabel());
      }
      return remove.size()>0;
   }

}
