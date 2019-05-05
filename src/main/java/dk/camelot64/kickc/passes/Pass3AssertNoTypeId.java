package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.InternalError;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.values.ConstantUnary;
import dk.camelot64.kickc.model.values.Value;

/**
 * Assert that no typeid() expressions exist in the code anymore (they must have been resolved to constants in phase 1-2)
 */
public class Pass3AssertNoTypeId extends Pass2SsaAssertion {

   public Pass3AssertNoTypeId(Program program) {
      super(program);
   }

   @Override
   public void check() throws AssertionFailed {
      ProgramValueIterator.execute(getProgram(), (programValue, currentStmt, stmtIt, currentBlock) -> {
         Value value = programValue.get();
         if(value instanceof ConstantUnary) {
            if(Operators.TYPEID.equals(((ConstantUnary) value).getOperator())) {
               throw new InternalError(
                     "Error! Typeid() not resolved during compile. " +
                           "\n statement: " + currentStmt.toString(getProgram(), false)
                     , currentStmt.getSource()
               );
            }
         }
      });
   }
}
