package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ControlFlowGraphBaseVisitor;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.StatementReturn;

/** Asserts that the program does not contain returns with values (as they have been replaced with assignments) */
public class Pass2AssertNoReturnValues extends Pass2SsaAssertion {

   public Pass2AssertNoReturnValues(Program program) {
      super(program);
   }

   @Override
   public void check() throws AssertionFailed {

      ControlFlowGraphBaseVisitor<Void> checkCalls = new ControlFlowGraphBaseVisitor<Void>() {

         @Override
         public Void visitReturn(StatementReturn aReturn) {
            if(aReturn.getValue()!=null) {
               throw new AssertionFailed("No return values allowed! "+ aReturn);
            }
            return null;
         }

      };
      checkCalls.visitGraph(getGraph());
   }

}
