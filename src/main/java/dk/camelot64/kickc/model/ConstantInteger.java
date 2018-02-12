package dk.camelot64.kickc.model;

import java.util.ArrayList;

/** SSA form constant integer value */
public class ConstantInteger implements ConstantValue {

   private Long number;

   public ConstantInteger( Long number) {
      this.number = number;
   }

   public Long getNumber() {
      return number;
   }

   public SymbolType getType(ProgramScope scope) {
      return getType();
   }

   public SymbolType getType() {
      ArrayList<SymbolType> potentialTypes = new ArrayList<>();
      Long number = getNumber();
      for(SymbolTypeInteger typeInteger : SymbolType.getIntegerTypes()) {
         if(number >= typeInteger.getMinValue() && number <= typeInteger.getMaxValue()) {
            potentialTypes.add(typeInteger);
         }
      }
      return new SymbolTypeInline(potentialTypes);
   }

   @Override
   public String toString() {
      return toString(null);
   }

   @Override
   public String toString(Program program) {
      if(program == null) {
         return Long.toString(number);
      } else {
         return "(" + getType(program.getScope()).getTypeName() + ") " + Long.toString(number);
      }
   }

   @Override
   public boolean equals(Object o) {
      if(this == o) return true;
      if(o == null || getClass() != o.getClass()) return false;
      ConstantInteger that = (ConstantInteger) o;
      return number != null ? number.equals(that.number) : that.number == null;
   }

   @Override
   public int hashCode() {
      return number != null ? number.hashCode() : 0;
   }
}
