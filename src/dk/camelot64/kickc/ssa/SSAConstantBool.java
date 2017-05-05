package dk.camelot64.kickc.ssa;

/**
 * SSA form constant integer value
 */
public class SSAConstantBool implements SSAConstant {

   private Boolean value;

   public SSAConstantBool(Boolean value) {
      this.value = value;
   }

   @Override
   public String toString() {
      return Boolean.toString(value);
   }
}
