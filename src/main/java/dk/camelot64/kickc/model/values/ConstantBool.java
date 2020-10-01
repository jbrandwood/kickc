package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.types.SymbolType;

/**
 * SSA form constant integer value
 */
public class ConstantBool implements ConstantEnumerable<Boolean> {

   private Boolean value;

   public ConstantBool(Boolean value) {
      this.value = value;
   }

   @Override
   public SymbolType getType(ProgramScope scope) {
      return SymbolType.BOOLEAN;
   }

   @Override
   public Long getInteger() {
      if(value)
         return 1l;
      else
         return 0l;
   }

   @Override
   public ConstantLiteral calculateLiteral(ProgramScope scope) {
      return new ConstantBool(value);
   }

   @Override
   public Boolean getValue() {
      return value;
   }

   public Boolean getBool() {
      return value;
   }

   @Override
   public String toString() {
      return toString(null);
   }

   @Override
   public String toString(Program program) {
      return Boolean.toString(value);
   }

}
