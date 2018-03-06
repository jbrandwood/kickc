package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.types.SymbolType;

/**
 * SSA form constant integer value
 */
public class ConstantDouble implements ConstantLiteral<Double> {

   private Double number;

   public ConstantDouble(Double number) {
      this.number = number;
   }

   @Override
   public SymbolType getType(ProgramScope scope) {
      return SymbolType.DOUBLE;
   }

   @Override
   public Double getValue() {
      return number;
   }

   @Override
   public String toString() {
      return toString(null);
   }

   @Override
   public String toString(Program program) {
      if(program == null) {
         return Double.toString(number);
      } else {
         return "(" + SymbolType.VOID.getTypeName() + ") " + Double.toString(number);
      }
   }

}
