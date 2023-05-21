package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.GraphBaseVisitor;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.StatementCall;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.values.RValue;

import java.util.List;

/** Asserts that the program does not contain calls with parameters in PHI-call procedures */
public class Pass2AssertNoCallParameters extends Pass2SsaAssertion {

   public Pass2AssertNoCallParameters(Program program) {
      super(program);
   }

   @Override
   public void check() throws AssertionFailed {
      GraphBaseVisitor<Void> checkCalls = new GraphBaseVisitor<Void>() {
         @Override
         public Void visitCall(StatementCall call) {
            Procedure procedure = getScope().getProcedure(call.getProcedure());
            if(Procedure.CallingConvention.PHI_CALL.equals(procedure.getCallingConvention())) {
               List<RValue> parameters = call.getParameters();
               if(parameters != null && parameters.size() > 0) {
                  throw new AssertionFailed("No call parameters allowed for PHI-call procedures! " + call);
               }
            }
            return null;
         }
      };
      checkCalls.visitGraph(getGraph());
   }

}
