package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.values.Value;
import dk.camelot64.kickc.model.values.ValueList;

/**
 * Fail if any initializer lists are still present in the program
 */
public class Pass2AssertNoValueLists extends Pass2SsaAssertion {

   public Pass2AssertNoValueLists(Program program) {
      super(program);
   }

   @Override
   public void check() throws AssertionFailed {
      ProgramValueIterator.execute(getProgram(), (programValue, currentStmt, stmtIt, currentBlock) -> {
         final Value value = programValue.get();
         if(value instanceof ValueList) {
            throw new CompileError("Initializer list not supported.", currentStmt);
         }
      });
   }

}
