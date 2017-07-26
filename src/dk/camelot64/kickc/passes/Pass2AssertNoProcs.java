package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.icl.*;

/** Asserts that the graph contains no proc/endproc statements */
public class Pass2AssertNoProcs extends Pass2SsaAssertion {

   public Pass2AssertNoProcs(Program program) {
      super(program);
   }

   @Override
   public void check() throws AssertionFailed {

      ControlFlowGraphBaseVisitor<Void> checkCalls = new ControlFlowGraphBaseVisitor<Void>() {

         @Override
         public Void visitProcedureBegin(StatementProcedureBegin statement) {
            throw new AssertionFailed("No proc statements allowed! "+statement);
         }

         @Override
         public Void visitProcedureEnd(StatementProcedureEnd statement) {
            throw new AssertionFailed("No proc statements allowed! "+statement);
         }
      };
      checkCalls.visitGraph(getGraph());
   }

}
