package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.types.SymbolType;

import java.util.Objects;

/**
 * Constant string value
 */
public class ConstantString implements ConstantLiteral<String> {


   /** String encoding. */
   public static enum Encoding {
      PETSCII_MIXED("petscii_mixed", "pm"),
      PETSCII_UPPER("petscii_upper", "pu"),
      SCREENCODE_MIXED("screencode_mixed", "sm"),
      SCREENCODE_UPPER("screencode_upper", "su");

      public final String name;
      public final String suffix;

      Encoding(String name, String suffix) {
         this.name = name;
         this.suffix = suffix;
      }

   }

   /** The string value. */
   private String value;

   /** The encoding to use for the string. */
   private Encoding encoding;

   /** true if the string should be zero terminated. */
   private boolean zeroTerminated;

   public ConstantString(String value, Encoding encoding, boolean zeroTerminated) {
      this.value = value;
      this.encoding = encoding;
      this.zeroTerminated = zeroTerminated;
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

   public Encoding getEncoding() {
      return encoding;
   }

   public boolean isZeroTerminated() {
      return zeroTerminated;
   }

   @Override
   public String toString() {
      return toString(null);
   }

   @Override
   public String toString(Program program) {
      String suffix = (encoding.equals(Encoding.SCREENCODE_MIXED)) ? "" : encoding.suffix;
      suffix += zeroTerminated ? "" : "z";
      if(program == null) {
         return "\"" + value + "\"" + suffix;
      } else {
         return "(" + SymbolType.STRING.getTypeName() + ") " + "\"" + value + "\"" + suffix;
      }
   }

   @Override
   public boolean equals(Object o) {
      if(this == o) return true;
      if(o == null || getClass() != o.getClass()) return false;
      ConstantString that = (ConstantString) o;
      return zeroTerminated == that.zeroTerminated &&
            Objects.equals(value, that.value) &&
            encoding == that.encoding;
   }

   @Override
   public int hashCode() {
      return Objects.hash(value, encoding, zeroTerminated);
   }

   /**
    * Find any string escape sequences and convert them to the ASCII-equivalent character
    *
    * @param stringValue The string to convert
    * @return The string where any escape sequence has been converted to ASCII
    * @throws CompileError If the string value has a syntax error (unfinished or illegal escape sequences)
    */
   public static String stringEscapeToAscii(String stringValue) {
      StringBuilder stringResult = new StringBuilder();
      char[] stringChars = stringValue.toCharArray();
      int i = 0;
      while(i < stringChars.length) {
         // State: Normal - examine whether an escape is starting
         char stringChar = stringChars[i];
         if(stringChar == '\\') {
            // Escape started - handle it!
            i++;
            if(i >= stringChars.length) throw new CompileError("Unfinished string escape sequence at end of string");
            char escapeChar = stringChars[i];
            switch(escapeChar) {
               case 'n':
                  stringChar = '\n';
                  break;
               case 'r':
                  stringChar = '\r';
                  break;
               case 'f':
                  stringChar = '\f';
                  break;
               case '"':
                  stringChar = '"';
                  break;
               case '\'':
                  stringChar = '\'';
                  break;
               case '\\':
                  stringChar = '\\';
                  break;
               default:
                  throw new CompileError("Illegal string escape sequence \\" + escapeChar);
            }
         }
         // Output the char
         stringResult.append(stringChar);
         i++;
      }
      return stringResult.toString();
   }

   /**
    * Find any ASCII character that must be escaped to represent the string in source code - and convert them to the escaped string.
    *
    * @param stringValue The string to convert
    * @return The string where any character that must be escaped is converted to the escape sequence
    */
   public static String asciiToStringEscape(String stringValue) {
      StringBuilder stringResult = new StringBuilder();
      char[] stringChars = stringValue.toCharArray();
      for(char stringChar : stringChars) {
         switch(stringChar) {
            case '\n':
               stringResult.append("\\n");
               break;
            case '\r':
               stringResult.append("\\r");
               break;
            case '\f':
               stringResult.append("\\f");
               break;
            case '"':
               stringResult.append("\\\"");
               break;
            case '\\':
               stringResult.append("\\\\");
               break;
            default:
               stringResult.append(stringChar);
         }
      }
      return stringResult.toString();
   }


}
