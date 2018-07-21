package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.types.SymbolType;

/**
 * An zero-filled array. The size of the array is currently non-constant, but must be resolved to a constant before pass 3.
 * The array is allocated in the code memory (as a .fill() ).
 */
public class ArrayFilled implements RValue {

   private RValue size;

   private SymbolType elementType;

   public ArrayFilled(SymbolType elementType, RValue size) {
      this.size = size;
      this.elementType = elementType;
   }

   public SymbolType getElementType() {
      return elementType;
   }

   public RValue getSize() {
      return size;
   }

   public void setSize(RValue size) {
      this.size = size;
   }

   @Override
   public String toString() {
      return toString(null);
   }

   @Override
   public String toString(Program program) {
      StringBuilder out = new StringBuilder();
      out.append("{ fill( ");
      out.append(size.toString());
      out.append(", 0) }");
      return out.toString();
   }

}
