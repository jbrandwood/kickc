package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeArray;

/**
 * An zero-filled constant array. The array is allocated in the code memory (as a .fill() ).
 */
public class ConstantArrayFilled implements ConstantArray {

   private ConstantValue size;

   private SymbolType elementType;

   public ConstantArrayFilled(SymbolType elementType, ConstantValue size) {
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

   public ConstantValue getSize() {
      return size;
   }

   public void setSize(ConstantValue size) {
      this.size = size;
   }

   @Override
   public ConstantLiteral calculateLiteral(ProgramScope scope) {
      throw new ConstantNotLiteral("Cannot calculate literal array");
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
