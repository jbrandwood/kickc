package dk.camelot64.kickc.icl;

/**
 * SSA form constant integer value
 */
public class ConstantBool implements Constant {

   private Boolean value;

   public ConstantBool(Boolean value) {
      this.value = value;
   }

   @Override
   public String toString() {
      return getAsString();
   }

   @Override
   public String getAsTypedString(ProgramScope scope) {
      return //"("+SymbolTypeBasic.BOOLEAN.getTypeName()+") "+
            Boolean.toString(value);
   }

   @Override
   public String getAsString() {
      return Boolean.toString(value);
   }
}
