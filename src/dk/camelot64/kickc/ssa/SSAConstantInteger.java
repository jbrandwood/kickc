package dk.camelot64.kickc.ssa;

/**
 * SSA form constant integer value
 */
public class SSAConstantInteger implements SSAConstant {

   private Integer number;

   public SSAConstantInteger(Integer number) {
      this.number = number;
   }

   public Integer getNumber() {
      return number;
   }

   @Override
   public String toString() {
      return Integer.toString(number);
   }
}
