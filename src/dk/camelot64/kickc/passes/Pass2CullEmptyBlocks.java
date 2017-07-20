package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.CompileLog;
import dk.camelot64.kickc.icl.*;

import java.util.*;

/** Pass that culls empty control flow blocks from the program */
public class Pass2CullEmptyBlocks extends Pass2SsaOptimization {

   public Pass2CullEmptyBlocks(Program program, CompileLog log) {
      super(program, log);
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
            Map<LabelRef, LabelRef> replace = new LinkedHashMap<>();
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
                     RValue previousRValue = previousSymbol.getrValue();
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
         LabelRef removeBlockLabelRef = removeBlock.getLabel();
         Label removeBlockLabel = (Label) getSymbols().getSymbol(removeBlockLabelRef);
         removeBlockLabel.getScope().remove(removeBlockLabel);
         log.append("Culled Empty Block " + removeBlockLabel.getTypedName());
      }
      return remove.size()>0;
   }

}
