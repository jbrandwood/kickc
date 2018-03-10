package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.types.SymbolType;

/**
 * SSA form constant integer value
 */
public class ConstantString implements ConstantLiteral<String> {

   private String value;

   public ConstantString(String value) {
      this.value = value;
   }

   @Override
   public SymbolType getType(ProgramScope scope) {
      return SymbolType.STRING;
   }

   @Override
   public String getValue() {
      return value;
   }

   public String getString() {
      return value;
   }

   @Override
   public String toString() {
      return toString(null);
   }

   @Override
   public String toString(Program program) {
      if(program == null) {
         return "\"" + value + "\"";
      } else {
         return "(" + SymbolType.STRING.getTypeName() + ") " + "\"" + value + "\"";
      }
   }

}
