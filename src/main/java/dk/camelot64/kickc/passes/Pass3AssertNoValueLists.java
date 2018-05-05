package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.values.RValue;
import dk.camelot64.kickc.model.values.ValueList;

/**
 * Assert that no value lists still exist inside the code.
 */
public class Pass3AssertNoValueLists extends Pass2SsaAssertion {

   public Pass3AssertNoValueLists(Program program) {
      super(program);
   }

   @Override
   public void check() throws AssertionFailed {
      ValueReplacer.executeAll(getGraph(), (replaceable, currentStmt, stmtIt, currentBlock) -> {
         RValue value = replaceable.get();
         if(value instanceof ValueList) {
            throw new CompileError(
                  "Error! Value list not resolved to word constructor or array initializer" +
                        "\n value list: " + value.toString(getProgram()) +
                        "\n statement: " + currentStmt.toString(getProgram(), false)
                  , currentStmt.getSource()
            );
         }
      });

   }
}
