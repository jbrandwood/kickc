package dk.camelot64.kickc.ssa;

/**
 * SSA form constant integer value
 */
public class SSAConstantString implements SSAConstant {

   private String value;

   public SSAConstantString(String value) {
      this.value = value;
   }

   @Override
   public String toString() {
      return "\\"+value+"\\";
   }
}
