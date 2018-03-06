package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ControlFlowGraphBaseVisitor;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.values.RValue;
import dk.camelot64.kickc.model.statements.StatementCall;

import java.util.List;

/** Asserts that the program does not contain calls with parameters */
public class Pass2AssertNoCallParameters extends Pass2SsaAssertion {

   public Pass2AssertNoCallParameters(Program program) {
      super(program);
   }

   @Override
   public void check() throws AssertionFailed {

      ControlFlowGraphBaseVisitor<Void> checkCalls = new ControlFlowGraphBaseVisitor<Void>() {

         @Override
         public Void visitCall(StatementCall call) {
            List<RValue> parameters = call.getParameters();
            if(parameters != null && parameters.size() > 0) {
               throw new AssertionFailed("No call parameters allowed! " + call);
            }
            return null;
         }
      };
      checkCalls.visitGraph(getGraph());
   }

}
