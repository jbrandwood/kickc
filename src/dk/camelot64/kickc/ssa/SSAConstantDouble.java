package dk.camelot64.kickc.ssa;

/**
 * SSA form constant integer value
 */
public class SSAConstantDouble implements SSAConstant {

   private Double number;

   public SSAConstantDouble(Double number) {
      this.number= number;
   }

   @Override
   public String toString() {
      return Double.toString(number);
   }
}
