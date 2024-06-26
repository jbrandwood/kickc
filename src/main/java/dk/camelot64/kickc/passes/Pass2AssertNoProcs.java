package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.GraphBaseVisitor;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.StatementProcedureBegin;
import dk.camelot64.kickc.model.statements.StatementProcedureEnd;

/** Asserts that the graph contains no proc/endproc statements */
public class Pass2AssertNoProcs extends Pass2SsaAssertion {

   public Pass2AssertNoProcs(Program program) {
      super(program);
   }

   @Override
   public void check() throws AssertionFailed {

      GraphBaseVisitor<Void> checkCalls = new GraphBaseVisitor<Void>() {

         @Override
         public Void visitProcedureBegin(StatementProcedureBegin procedureBegin) {
            throw new AssertionFailed("No proc statements allowed! " + procedureBegin);
         }

         @Override
         public Void visitProcedureEnd(StatementProcedureEnd procedureEnd) {
            throw new AssertionFailed("No proc statements allowed! " + procedureEnd);
         }
      };
      checkCalls.visitGraph(getGraph());
   }

}
