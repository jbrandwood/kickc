package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementReturn;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.symbols.Scope;
import dk.camelot64.kickc.model.values.ScopeRef;

/** Asserts that the program does not contain returns with values in PHI-call procedures (as they have been replaced with assignments) */
public class Pass2AssertNoReturnValues extends Pass2SsaAssertion {

   public Pass2AssertNoReturnValues(Program program) {
      super(program);
   }

   @Override
   public void check() throws AssertionFailed {
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         ScopeRef blockScopeRef = block.getScope();
         Scope scope = getScope().getScope(blockScopeRef);
         if(scope instanceof Procedure) {
            Procedure procedure = (Procedure) scope;
            if(Procedure.CallingConvension.PHI_CALL.equals(procedure.getCallingConvension())) {
               for(Statement statement : block.getStatements()) {
                  if(statement instanceof StatementReturn) {
                     StatementReturn aReturn = (StatementReturn) statement;
                     if(aReturn.getValue() != null) {
                        throw new AssertionFailed("No return values allowed! " + aReturn);
                     }
                  }
               }
            }
         }
      }
   }

}
