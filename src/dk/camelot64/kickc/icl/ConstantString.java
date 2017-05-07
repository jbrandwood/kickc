package dk.camelot64.kickc.icl;

/**
 * SSA form constant integer value
 */
public class ConstantString implements Constant {

   private String value;

   public ConstantString(String value) {
      this.value = value;
   }

   @Override
   public String toString() {
      return "\\"+value+"\\";
   }
}
