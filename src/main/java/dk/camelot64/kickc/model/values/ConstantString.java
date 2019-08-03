package dk.camelot64.kickc.model.values;

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
      SCREENCODE_UPPER("screencode_upper", "su")
      ;

      public final String name;
      public final String suffix;

      Encoding(String name, String suffix) {
         this.name = name;
         this.suffix = suffix;
      }

   }

   private String value;

   private Encoding encoding;

   public ConstantString(String value, Encoding encoding) {
      this.value = value;
      this.encoding = encoding;
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

   @Override
   public String toString() {
      return toString(null);
   }

   @Override
   public String toString(Program program) {
      String enc = (encoding.equals(Encoding.SCREENCODE_MIXED))?"":encoding.suffix;
      if(program == null) {
         return "\"" + value + "\""+enc;
      } else {
         return "(" + SymbolType.STRING.getTypeName() + ") "+"\"" + value + "\""+enc;
      }
   }

   @Override
   public boolean equals(Object o) {
      if(this == o) return true;
      if(o == null || getClass() != o.getClass()) return false;
      ConstantString that = (ConstantString) o;
      return Objects.equals(value, that.value) &&
            encoding == that.encoding;
   }

   @Override
   public int hashCode() {
      return Objects.hash(value, encoding);
   }
}
