package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.statements.StatementCall;
import dk.camelot64.kickc.model.statements.StatementConditionalJump;
import dk.camelot64.kickc.model.statements.StatementJump;
import dk.camelot64.kickc.model.statements.StatementPhiBlock;
import dk.camelot64.kickc.model.values.LabelRef;
import dk.camelot64.kickc.model.values.ProcedureRef;
import dk.camelot64.kickc.model.values.SymbolRef;

import java.util.Collection;
import java.util.HashSet;
import java.util.Set;

/** Assert that all referenced blocks exist in the program */
public class Pass2AssertBlocks extends Pass2SsaAssertion {

   public Pass2AssertBlocks(Program program) {
      super(program);
   }

   @Override
   public void check() throws AssertionFailed {
      BlockReferenceChecker blockReferenceFinder = new BlockReferenceChecker(getGraph());
      blockReferenceFinder.visitGraph(getGraph());

      Set<LabelRef> seenBlocks = blockReferenceFinder.getSeenBlocks();
      Collection<ControlFlowBlock> allBlocks = getGraph().getAllBlocks();
      for(LabelRef seenBlock : seenBlocks) {
         ControlFlowBlock block = getGraph().getBlock(seenBlock);
         if(!allBlocks.contains(block)) {
            throw new AssertionFailed("Compilation Process Error! A block in the program is not contained in the allBocks list (probably a block sequence problem). " + seenBlock);
         }
      }
   }

   private static class BlockReferenceChecker extends ControlFlowGraphBaseVisitor<Void> {

      Set<LabelRef> seenBlocks;
      private ControlFlowGraph graph;

      public BlockReferenceChecker(ControlFlowGraph graph) {
         this.graph = graph;
         this.seenBlocks = new HashSet<>();
      }

      public Set<LabelRef> getSeenBlocks() {
         return seenBlocks;
      }

      private void assertBlock(LabelRef blockLabel) throws AssertionFailed {
         if(blockLabel == null) {
            return;
         }
         if(blockLabel.getFullName().equals(SymbolRef.PROCEXIT_BLOCK_NAME)) {
            return;
         }
         seenBlocks.add(blockLabel);
         ControlFlowBlock block = graph.getBlock(blockLabel);
         if(block == null) {
            throw new AssertionFailed("Compilation Process Error! Block referenced, but not found in program. " + blockLabel);
         }
      }

      @Override
      public Void visitBlock(ControlFlowBlock block) {
         assertBlock(block.getDefaultSuccessor());
         assertBlock(block.getCallSuccessor());
         assertBlock(block.getConditionalSuccessor());
         return super.visitBlock(block);
      }


      @Override
      public Void visitConditionalJump(StatementConditionalJump conditionalJump) {
         assertBlock(conditionalJump.getDestination());
         return super.visitConditionalJump(conditionalJump);
      }

      @Override
      public Void visitCall(StatementCall call) {
         ProcedureRef procedure = call.getProcedure();
         LabelRef procLabelRef = procedure.getLabelRef();
         assertBlock(procLabelRef);
         return super.visitCall(call);
      }

      @Override
      public Void visitPhiBlock(StatementPhiBlock phi) {
         for(StatementPhiBlock.PhiVariable phiVariable : phi.getPhiVariables()) {
            for(StatementPhiBlock.PhiRValue phiRValue : phiVariable.getValues()) {
               assertBlock(phiRValue.getPredecessor());
            }
         }
         return super.visitPhiBlock(phi);
      }

      @Override
      public Void visitJump(StatementJump jump) {
         assertBlock(jump.getDestination());
         return super.visitJump(jump);
      }
   }

}
