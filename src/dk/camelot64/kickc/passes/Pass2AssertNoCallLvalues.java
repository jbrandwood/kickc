package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.icl.ControlFlowGraphBaseVisitor;
import dk.camelot64.kickc.icl.Program;
import dk.camelot64.kickc.icl.RValue;
import dk.camelot64.kickc.icl.StatementCall;

import java.util.List;

/** Asserts that the program does not contain calls with lValues */
public class Pass2AssertNoCallLvalues extends Pass2SsaAssertion {

   public Pass2AssertNoCallLvalues(Program program) {
      super(program);
   }

   @Override
   public void check() throws AssertionFailed {

      ControlFlowGraphBaseVisitor<Void> checkCalls = new ControlFlowGraphBaseVisitor<Void>() {

         @Override
         public Void visitCall(StatementCall callLValue) {
            if(callLValue.getlValue()!=null) {
               throw new AssertionFailed("No call lValue allowed! "+callLValue);
            }
            return null;
         }
      };
      checkCalls.visitGraph(getGraph());
   }

}
