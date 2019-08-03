package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.types.SymbolType;

/**
 * SSA form constant char value (a byte)
 */
public class ConstantChar implements ConstantLiteral<Character> {

   /** The character. */
   private Character value;

   /** The encoding of the character. */
   private ConstantString.Encoding encoding;

   public ConstantChar(Character value, ConstantString.Encoding encoding) {
      this.value = value;
      this.encoding = encoding;
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

   public ConstantString.Encoding getEncoding() {
      return encoding;
   }

   @Override
   public String toString() {
      return toString(null);
   }

   @Override
   public String toString(Program program) {
      String enc = (encoding.equals(ConstantString.Encoding.SCREENCODE_MIXED))?"":encoding.suffix;
      if(program == null) {
         return "'" + value + "'"+enc;
      } else {
         return "(" + SymbolType.BYTE.getTypeName() + ") " + "'" + value + "'"+enc;
      }
   }

}
