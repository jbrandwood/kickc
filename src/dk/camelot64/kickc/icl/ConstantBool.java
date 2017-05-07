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
      return Boolean.toString(value);
   }
}
