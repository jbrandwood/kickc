package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.ConstantNotLiteral;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypePointer;

import java.util.List;

/**
 * An array of constants. The array is allocated in the code memory (eg. as a set of .byte's ).
 */
public class ConstantArrayList implements ConstantArray {

   /** The element list. */
   private List<ConstantValue> list;

   /** Type of the elements. */
   private SymbolType elementType;

   /** Array size (from declaration) */
   private ConstantValue size;

   public ConstantArrayList(List<ConstantValue> list, SymbolType elementType, ConstantValue size) {
      this.list = list;
      this.elementType = elementType;
      this.size = size;
   }

   @Override
   public SymbolType getType(ProgramScope scope) {
      return new SymbolTypePointer(elementType);
   }

   public SymbolType getElementType() {
      return elementType;
   }

   public List<ConstantValue> getElements() {
      return list;
   }

   @Override
   public ConstantValue getSize() {
      return size;
   }

   public void setSize(ConstantValue size) {
      this.size = size;
   }

   @Override
   public ConstantLiteral calculateLiteral(ProgramScope scope) {
      throw ConstantNotLiteral.getException();
   }

   @Override
   public String toString() {
      return toString(null);
   }

   @Override
   public String toString(Program program) {
      StringBuilder out = new StringBuilder();
      boolean first = true;
      out.append("{ ");
      for(ConstantValue constantValue : list) {
         if(!first) {
            out.append(", ");
         }
         first = false;
         out.append(constantValue.toString(null));
      }
      out.append(" }");
      return out.toString();
   }

}
