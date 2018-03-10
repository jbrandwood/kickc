package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.types.SymbolType;

/**
 * SSA form constant char value (a byte)
 */
public class ConstantChar implements ConstantLiteral<Character> {

   private Character value;

   public ConstantChar(Character value) {
      this.value = value;
   }

   @Override
   public SymbolType getType(ProgramScope scope) {
      return SymbolType.BYTE;
   }

   @Override
   public Character getValue() {
      return value;
   }

   public Character getChar() {
      return value;
   }

   @Override
   public String toString() {
      return toString(null);
   }

   @Override
   public String toString(Program program) {
      if(program == null) {
         return "'" + value + "'";
      } else {
         return "(" + SymbolType.BYTE.getTypeName() + ") " + "'" + value + "'";
      }
   }

}
