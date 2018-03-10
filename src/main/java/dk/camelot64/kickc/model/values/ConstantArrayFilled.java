package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeArray;

/**
 * An zero-filled constant array. The array is allocated in the code memory (as a .fill() ).
 */
public class ConstantArrayFilled implements ConstantValue {

   private int size;

   private SymbolType elementType;

   public ConstantArrayFilled(SymbolType elementType, int size) {
      this.size = size;
      this.elementType = elementType;
   }

   @Override
   public SymbolType getType(ProgramScope scope) {
      return new SymbolTypeArray(elementType);
   }

   public SymbolType getElementType() {
      return elementType;
   }

   public int getSize() {
      return size;
   }

   @Override
   public ConstantLiteral calculate(ProgramScope scope) {
      throw new CompileError("Cannot calculate literal array");
   }

   @Override
   public String toString() {
      return toString(null);
   }

   @Override
   public String toString(Program program) {
      StringBuilder out = new StringBuilder();
      out.append("{ fill( ");
      out.append(size);
      out.append(", 0) }");
      return out.toString();
   }

}
