package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.InternalError;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.values.RangeValue;
import dk.camelot64.kickc.model.values.Value;

/**
 * Assert that all intermediate RValues in the code have been replaced in pass 2.
 * This disallows:
 * - ValueList
 * - RangeComparison/RangeNext
 */
public class Pass3AssertRValues extends Pass2SsaAssertion {

   public Pass3AssertRValues(Program program) {
      super(program);
   }

   @Override
   public void check() throws AssertionFailed {
      ProgramValueIterator.execute(getGraph(), (programValue, currentStmt, stmtIt, currentBlock) -> {
         Value value = programValue.get();
         if(value instanceof RangeValue) {
            throw new InternalError(
                  "Error! Ranged for() not resolved to constants" +
                        "\n Range: " + value.toString(getProgram()) +
                        "\n statement: " + currentStmt.toString(getProgram(), false)
                  , currentStmt.getSource()
            );
         }
      });
   }
}
