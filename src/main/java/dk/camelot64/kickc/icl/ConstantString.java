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
       return toString(null);
   }

   @Override
   public String toString(Program program) {
      if (program == null) {
         return "\\" + value + "\\";
      } else {
         return "(" + SymbolTypeBasic.STRING.getTypeName() + ") " + "\\" + value + "\\";
      }
   }

}
