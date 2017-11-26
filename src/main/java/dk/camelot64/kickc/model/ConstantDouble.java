package dk.camelot64.kickc.model;

/**
 * SSA form constant integer value
 */
public class ConstantDouble implements ConstantValue {

   private Double number;

   public ConstantDouble(Double number) {
      this.number = number;
   }

   @Override
   public SymbolType getType(ProgramScope scope) {
      return SymbolType.DOUBLE;
   }

   public Double getNumber() {
      return number;
   }

   @Override
   public String toString() {
      return toString(null);
   }

   @Override
   public String toString(Program program) {
      if(program ==null) {
         return Double.toString(number);
      }  else {
         return "(" + SymbolType.VOID.getTypeName() + ") " + Double.toString(number);
      }
   }

}
