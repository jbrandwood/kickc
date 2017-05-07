package dk.camelot64.kickc.icl;

/**
 * SSA form constant integer value
 */
public class ConstantInteger implements Constant {

   private Integer number;

   public ConstantInteger(Integer number) {
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
