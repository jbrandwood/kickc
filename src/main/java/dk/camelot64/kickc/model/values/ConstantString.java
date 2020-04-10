package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypePointer;

import java.util.Objects;

/**
 * Constant string value
 */
public class ConstantString implements ConstantLiteral<String> {

   /** The string value. */
   private String value;

   /** The encoding to use for the string. */
   private StringEncoding encoding;

   /** true if the string should be zero terminated. */
   private boolean zeroTerminated;

   public ConstantString(String value, StringEncoding encoding, boolean zeroTerminated) {
      this.value = value;
      this.encoding = encoding;
      this.zeroTerminated = zeroTerminated;
   }

   @Override
   public SymbolType getType(ProgramScope scope) {
      return new SymbolTypePointer(SymbolType.BYTE);
   }

   @Override
   public String getValue() {
      return value;
   }

   public String getString() {
      return value;
   }

   public StringEncoding getEncoding() {
      return encoding;
   }

   /**
    * Get the string where characters have been escaped. (eg. newline as '\n')
    * @return The escaped string.
    */
   public String getStringEscaped() {
      return encoding.asciiToEscape(value);
   }

   public boolean isZeroTerminated() {
      return zeroTerminated;
   }

   /**
    * Get the length of the string - including zero-termination if present.
    *
    * @return The length
    */
   public int getStringLength() {
      return value.length() + (zeroTerminated ? 1 : 0);
   }

   @Override
   public String toString() {
      return toString(null);
   }

   @Override
   public String toString(Program program) {
      String suffix = (encoding.equals(StringEncoding.SCREENCODE_MIXED)) ? "" : encoding.suffix;
      suffix += zeroTerminated ? "" : "z";
      if(program == null) {
         return "\"" + value + "\"" + suffix;
      } else {
         return "(" + getType(program.getScope()).getTypeName() + ") " + "\"" + value + "\"" + suffix;
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


}
