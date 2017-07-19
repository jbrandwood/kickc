package dk.camelot64.kickc.icl;

/**
 * SSA form constant integer value
 */
public class ConstantDouble implements Constant {

   private Double number;

   public ConstantDouble(Double number) {
      this.number = number;
   }

   public Double getNumber() {
      return number;
   }

   @Override
   public String toString() {
      return getAsString();
   }

   @Override
   public String getAsTypedString(ProgramScope scope) {
      return "(" + SymbolTypeBasic.VOID.getTypeName() + ") " + Double.toString(number);
   }

   @Override
   public String getAsString() {
      return Double.toString(number);
   }
}
