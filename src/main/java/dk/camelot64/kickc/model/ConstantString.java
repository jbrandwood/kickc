package dk.camelot64.kickc.model;

/**
 * SSA form constant integer value
 */
public class ConstantString implements ConstantValue {

   private String value;

   public ConstantString(String value) {
      this.value = value;
   }

   @Override
   public SymbolType getType(ProgramScope scope) {
      return SymbolType.STRING;
   }

   public String getValue() {
      return value;
   }

   @Override
   public String toString() {
       return toString(null);
   }

   @Override
   public String toString(Program program) {
      if (program == null) {
         return "\"" + value + "\"";
      } else {
         return "(" + SymbolType.STRING.getTypeName() + ") " + "\"" + value + "\"";
      }
   }

}
