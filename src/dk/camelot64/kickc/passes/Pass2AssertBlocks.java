package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.icl.*;

/** Assert that all referenced blocks exist in the program */
public class Pass2AssertBlocks extends Pass2SsaAssertion {

   public Pass2AssertBlocks(ControlFlowGraph graph, Scope scope) {
      super(graph, scope);
   }

   @Override
   public void check() throws AssertionFailed {
      ControlFlowGraphBaseVisitor<Void> blockReferenceFinder = new BlockReferenceChecker(getGraph());
      blockReferenceFinder.visitGraph(getGraph());
   }

   private static class BlockReferenceChecker extends ControlFlowGraphBaseVisitor<Void> {

      private ControlFlowGraph graph;

      public BlockReferenceChecker(ControlFlowGraph graph) {
         this.graph = graph;
      }

      private void assertBlock(Label blockLabel) throws AssertionFailed {
         if (blockLabel == null) {
            return;
         }
         if (blockLabel.getFullName().equals("@RETURN")) {
            return;
         }
         ControlFlowBlock block = graph.getBlock(blockLabel);
         if (block == null) {
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
      public Void visitCall(StatementCall callLValue) {
         assertBlock(callLValue.getProcedure().getLabel());
         return super.visitCall(callLValue);
      }

      @Override
      public Void visitPhi(StatementPhi phi) {
         for (StatementPhi.PreviousSymbol previousSymbol : phi.getPreviousVersions()) {
            assertBlock(previousSymbol.getBlock());
         }
         return super.visitPhi(phi);
      }

      @Override
      public Void visitJump(StatementJump jump) {
         assertBlock(jump.getDestination());
         return super.visitJump(jump);
      }
   }

}
