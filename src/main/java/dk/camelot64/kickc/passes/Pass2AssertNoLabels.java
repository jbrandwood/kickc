package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ControlFlowGraphBaseVisitor;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.StatementLabel;

/** Asserts that the graph contains no label statements */
public class Pass2AssertNoLabels extends Pass2SsaAssertion {

   public Pass2AssertNoLabels(Program program) {
      super(program);
   }

   @Override
   public void check() throws AssertionFailed {

      ControlFlowGraphBaseVisitor<Void> checkCalls = new ControlFlowGraphBaseVisitor<Void>() {

         @Override
         public Void visitJumpTarget(StatementLabel jumpTarget) {
            throw new AssertionFailed("No label statements allowed! " + jumpTarget);
         }
      };
      checkCalls.visitGraph(getGraph());
   }

}
