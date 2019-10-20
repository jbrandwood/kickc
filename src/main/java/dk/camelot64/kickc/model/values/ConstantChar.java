package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.InternalError;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.types.SymbolType;
import kickass.nonasm.c64.CharToPetsciiConverter;

/**
 * SSA form constant char value (a byte)
 */
public class ConstantChar implements ConstantEnumerable<Character> {

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

   /**
    * Get the integer value of the character
    * @return The integer value (taking encoding into account)
    */
   @Override
   public Long getInteger() {
      Byte constCharIntValue = null;
      if(ConstantString.Encoding.SCREENCODE_MIXED.equals(encoding)) {
         constCharIntValue = CharToPetsciiConverter.charToScreenCode_mixed.get(value);
      }  else if(ConstantString.Encoding.SCREENCODE_UPPER.equals(encoding)) {
         constCharIntValue = CharToPetsciiConverter.charToScreenCode_upper.get(value);
      }  else if(ConstantString.Encoding.PETSCII_MIXED.equals(encoding)) {
         constCharIntValue = CharToPetsciiConverter.charToPetscii_mixed.get(value);
      }  else if(ConstantString.Encoding.PETSCII_UPPER.equals(encoding)) {
         constCharIntValue = CharToPetsciiConverter.charToPetscii_upper.get(value);
      }
      return constCharIntValue.longValue();
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
      String enc = (encoding.equals(ConstantString.Encoding.SCREENCODE_MIXED)) ? "" : encoding.suffix;
      if(program == null) {
         return "'" + value + "'" + enc;
      } else {
         return "(" + SymbolType.BYTE.getTypeName() + ") " + "'" + value + "'" + enc;
      }
   }

   /**
    * Parses a potentially escaped char
    *
    * @param charString Either just a single char - or an escaped char using \-notation
    * @return The ASCII char
    */
   public static char charEscapeToAscii(String charString) {
      if(charString.length() == 1) {
         return charString.charAt(0);
      } else if(charString.length() == 2) {
         switch(charString.charAt(1)) {
            case 'n':
               return '\n';
            case 'r':
               return '\r';
            case 'f':
               return '\f';
            case '"':
               return '\"';
            case '\'':
               return '\'';
            case '\\':
               return '\\';
            default:
               throw new CompileError("Illegal char escape sequence \\" + charString.charAt(1));
         }
      } else {
         throw new InternalError("Illegal char '" + charString + "'");
      }
   }

   /**
    * Converts a char to an escape sequence if needed. If not needed the char itself is returned.
    * @param aChar The char
    * @return The char itself - or the appropriate escape sequence
    */
   public static String asciiToCharEscape(char aChar) {
      switch(aChar) {
         case '\n':
            return "\\n";
         case '\r':
            return "\\r";
         case '\f':
            return "\\f";
         case '\'':
            return "\\'";
         case '\\':
            return "\\\\";
         default:
            return Character.toString(aChar);
      }
   }



}
