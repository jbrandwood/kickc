package dk.camelot64.kickc.icl;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;

/** SSA form constant integer value */
public class ConstantInteger implements ConstantValue {

   private Integer number;

   @JsonCreator
   public ConstantInteger(
         @JsonProperty("number") Integer number) {
      this.number = number;
   }

   public Integer getNumber() {
      return number;
   }

   @JsonIgnore
   public SymbolType getType(ProgramScope scope) {
      return getType();
   }

   public SymbolType getType() {
      SymbolType type;
      if (getNumber() < 256) {
         type = SymbolTypeBasic.BYTE;
      } else {
         type = SymbolTypeBasic.WORD;
      }
      return type;
   }

   @Override
   public String toString() {
      return toString(null);
   }

   @Override
   public String toString(Program program) {
      if (program == null) {
         return Integer.toString(number);
      } else {
         return "(" + getType(program.getScope()).getTypeName() + ") " + Integer.toString(number);
      }
   }

   @Override
   public boolean equals(Object o) {
      if (this == o) return true;
      if (o == null || getClass() != o.getClass()) return false;
      ConstantInteger that = (ConstantInteger) o;
      return number != null ? number.equals(that.number) : that.number == null;
   }

   @Override
   public int hashCode() {
      return number != null ? number.hashCode() : 0;
   }
}
