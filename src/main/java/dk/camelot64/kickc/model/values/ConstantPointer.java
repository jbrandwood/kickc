package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypePointer;

/** Constant pointer (meaning it points to a constant location)*/
public class ConstantPointer implements ConstantEnumerable<Long> {

   /** The memory location pointed to. */
   private Long location;

   /** The type of the element pointed to. */
   private SymbolType elementType;

   public ConstantPointer(Long location, SymbolType elementType) {
      this.location = location;
      this.elementType = elementType;
   }

   @Override
   public Long getValue() {
      return location;
   }

   public Long getLocation() {
      return location;
   }

   @Override
   public Long getInteger() {
      return location;
   }

   public SymbolType getType(ProgramScope scope) {
      return getType();
   }

   public SymbolType getType() {
      return new SymbolTypePointer(elementType);
   }

   public SymbolType getElementType() {
      return elementType;
   }

   @Override
   public String toString() {
      return toString(null);
   }

   @Override
   public String toString(Program program) {
      if(program == null) {
         return Long.toString(location);
      } else {
         return "(" + getType(program.getScope()).getTypeName() + ") " + Long.toString(location);
      }
   }

   @Override
   public boolean equals(Object o) {
      if(this == o) return true;
      if(o == null || getClass() != o.getClass()) return false;

      ConstantPointer that = (ConstantPointer) o;

      if(!location.equals(that.location)) return false;
      return elementType.equals(that.elementType);
   }

   @Override
   public int hashCode() {
      int result = location.hashCode();
      result = 31 * result + elementType.hashCode();
      return result;
   }
}
