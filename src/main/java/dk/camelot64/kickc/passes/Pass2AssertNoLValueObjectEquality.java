package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.InternalError;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramValue;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.values.ConstantValue;
import dk.camelot64.kickc.model.values.SymbolRef;
import dk.camelot64.kickc.model.values.Value;

import java.util.HashMap;

/** Asserts that the program does not contain calls with lValues */
public class Pass2AssertNoLValueObjectEquality extends Pass2SsaAssertion {

   public Pass2AssertNoLValueObjectEquality(Program program) {
      super(program);
   }

   @Override
   public void check() throws AssertionFailed {
      HashMap<Value, ValueInProgram> allValues = new HashMap<>();
      ProgramValueIterator.execute(getGraph(), (programValue, currentStmt, stmtIt, currentBlock) -> {
         Value value = programValue.get();
         if(value!=null && !(value instanceof SymbolRef) && !(value instanceof ConstantValue)) {
            ValueInProgram other = allValues.get(value);
            if(other != null) {
               if(other.value == value)
                  throw new InternalError("Error! Value object equality in program " + value.toString(getProgram()), currentStmt.getSource());
            } else {
               allValues.put(value, new ValueInProgram(value, programValue));
            }
         }
      });
   }

   private static class ValueInProgram {
      Value value;
      ProgramValue programValue;

      public ValueInProgram(Value value, ProgramValue programValue) {
         this.value = value;
         this.programValue = programValue;
      }
   }

}
