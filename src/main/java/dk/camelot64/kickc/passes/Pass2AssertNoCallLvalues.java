package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ControlFlowGraphBaseVisitor;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.StatementCall;

/** Asserts that the program does not contain calls with lValues */
public class Pass2AssertNoCallLvalues extends Pass2SsaAssertion {

   public Pass2AssertNoCallLvalues(Program program) {
      super(program);
   }

   @Override
   public void check() throws AssertionFailed {

      ControlFlowGraphBaseVisitor<Void> checkCalls = new ControlFlowGraphBaseVisitor<Void>() {

         @Override
         public Void visitCall(StatementCall call) {
            if(call.getlValue() != null) {
               throw new AssertionFailed("No call lValue allowed! " + call);
            }
            return null;
         }
      };
      checkCalls.visitGraph(getGraph());
   }

}
