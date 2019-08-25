package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.asm.AsmFormat;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.types.SymbolType;

/** Constant integer value */
public class ConstantInteger implements ConstantEnumerable<Long> {

   private Long number;

   /** The type of the number. (Either fixed size og the "number" type) */
   private SymbolType type;

   public ConstantInteger(Long number) {
      this.number = number;
      this.type = SymbolType.NUMBER;
   }

   public ConstantInteger(Long number, SymbolType type) {
      this.number = number;
      if(type != null) {
         this.type = type;
      } else {
         this.type = SymbolType.NUMBER;
      }
   }

   @Override
   public Long getValue() {
      return number;
   }

   public Long getInteger() {
      return number;
   }

   public SymbolType getType(ProgramScope scope) {
      return getType();
   }

   public SymbolType getType() {
      return type;
   }

   public void setType(SymbolType type) {
      this.type = type;
   }

   @Override
   public String toString() {
      return toString(null);
   }

   @Override
   public String toString(Program program) {
      if(program == null) {
         return AsmFormat.getAsmNumber(number);
      } else {
         return "(" + getType(program.getScope()).getTypeName() + ") " + AsmFormat.getAsmNumber(number);
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
