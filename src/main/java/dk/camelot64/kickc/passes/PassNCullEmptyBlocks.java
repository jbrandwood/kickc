package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.ControlFlowGraphBaseVisitor;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.StatementPhiBlock;
import dk.camelot64.kickc.model.symbols.Label;
import dk.camelot64.kickc.model.values.LabelRef;
import dk.camelot64.kickc.model.values.RValue;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/** Pass that culls empty control flow blocks from the program */
public class PassNCullEmptyBlocks extends Pass2SsaOptimization {

   private boolean pass1;

   public PassNCullEmptyBlocks(Program program, boolean pass1) {
      super(program);
      this.pass1 = pass1;
   }

   @Override
   public boolean step() {
      final List<ControlFlowBlock> remove = new ArrayList<>();
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         if(block.getStatements().isEmpty() && block.getLabel().isIntermediate()) {
            remove.add(block);
         }
      }

      List<ControlFlowBlock> dontRemove = new ArrayList<>();

      for(final ControlFlowBlock removeBlock : remove) {
         ControlFlowBlock successor = getGraph().getDefaultSuccessor(removeBlock);
         if(successor==null) {
            dontRemove.add(removeBlock);
            continue;
         }
         LabelRef successorRef = successor.getLabel();
         // Replace all jumps (default/conditional/call) to @removeBlock with a jump to the default successor
         final List<ControlFlowBlock> predecessors = getGraph().getPredecessors(removeBlock);

         // If a candidate remove block has a predecessor that has the same successor as the remove block:
         // Do not remove it - because this will result in problems in distinguishing the default successor and
         // the conditional successor when generating the phi-block of the successor
         boolean dontCull = false;
         for(ControlFlowBlock predecessor : predecessors) {
            if(successorRef.equals(predecessor.getConditionalSuccessor()) || successorRef.equals(predecessor.getDefaultSuccessor())) {
               if(getLog().isVerboseNonOptimization()) {
                  getLog().append("Not culling empty block because it shares successor with its predecessor. " + removeBlock.getLabel().toString(getProgram()));
               }
               dontCull = true;
               dontRemove.add(removeBlock);
            }
         }
         if(dontCull)
            continue;

         // In all phi functions of a successor blocks make a copy of the phi assignment for each predecessor
         ControlFlowGraphBaseVisitor<Void> phiFixVisitor = new ControlFlowGraphBaseVisitor<Void>() {
            @Override
            public Void visitPhiBlock(StatementPhiBlock phi) {
               for(StatementPhiBlock.PhiVariable phiVariable : phi.getPhiVariables()) {
                  for(StatementPhiBlock.PhiRValue phiRValue : phiVariable.getValues()) {
                     if(phiRValue.getPredecessor().equals(removeBlock.getLabel())) {
                        // Found a phi function referencing the remove block - add copies for each predecessor
                        RValue previousRValue = phiRValue.getrValue();
                        for(ControlFlowBlock predecessor : predecessors) {
                           if(phiRValue != null) {
                              phiRValue.setPredecessor(predecessor.getLabel());
                              phiRValue = null;
                           } else {
                              phiVariable.setrValue(predecessor.getLabel(), previousRValue);
                           }
                        }
                        break;
                     }
                  }
               }
               return null;
            }
         };
         phiFixVisitor.visitBlock(successor);

         for(ControlFlowBlock predecessor : predecessors) {
            Map<LabelRef, LabelRef> replace = new LinkedHashMap<>();
            replace.put(removeBlock.getLabel(), successorRef);
            if(removeBlock.getLabel().equals(predecessor.getDefaultSuccessor())) {
               predecessor.setDefaultSuccessor(successorRef);
            }
            if(removeBlock.getLabel().equals(predecessor.getConditionalSuccessor())) {
               predecessor.setConditionalSuccessor(successorRef);
            }
            if(removeBlock.getLabel().equals(predecessor.getCallSuccessor())) {
               predecessor.setCallSuccessor(successorRef);
            }
            replaceLabels(predecessor, replace);
         }
         getGraph().getAllBlocks().remove(removeBlock);
         LabelRef removeBlockLabelRef = removeBlock.getLabel();
         Label removeBlockLabel = getProgramScope().getLabel(removeBlockLabelRef);
         removeBlockLabel.getScope().remove(removeBlockLabel);
         if(!pass1)
            getLog().append("Culled Empty Block " + removeBlockLabel.toString(getProgram()));
      }
      remove.removeAll(dontRemove);
      return remove.size() > 0;
   }

}
