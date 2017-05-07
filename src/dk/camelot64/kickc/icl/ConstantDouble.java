package dk.camelot64.kickc.icl;

/**
 * SSA form constant integer value
 */
public class ConstantDouble implements Constant {

   private Double number;

   public ConstantDouble(Double number) {
      this.number= number;
   }

   @Override
   public String toString() {
      return Double.toString(number);
   }
}
