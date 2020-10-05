package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.types.SymbolType;

/**
 * SSA form constant char value (a byte)
 */
public class ConstantChar implements ConstantEnumerable<Character> {

   /** The character. */
   private Character value;

   /** The encoding of the character. */
   private StringEncoding encoding;

   public ConstantChar(Character value, StringEncoding encoding) {
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

   /**
    * Get the integer value of the character
    *
    * @return The integer value (taking encoding into account)
    */
   @Override
   public Long getInteger() {
      return (long) encoding.encodedFromChar(value);
   }

   public StringEncoding getEncoding() {
      return encoding;
   }

   /**
    * Get the char where any special character has been properly escaped (eg '\n' for a newline).
    *
    * @return The character with escapes if needed.
    */
   public String getCharEscaped() {
      return encoding.asciiToEscapedEncoded(value, true);
   }

   @Override
   public String toString() {
      return toString(null);
   }

   @Override
   public String toString(Program program) {
      String enc = (encoding.equals(StringEncoding.SCREENCODE_MIXED)) ? "" : encoding.suffix;
      return "'" + value + "'" + enc;
   }

}
