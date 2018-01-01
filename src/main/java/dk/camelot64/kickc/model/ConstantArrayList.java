package dk.camelot64.kickc.model;

import java.util.List;

/**
 * An array of constants. The array is allocated in the code memory (eg. as a set of .byte's ).
 */
public class ConstantArrayList implements ConstantValue {

   private List<ConstantValue> list;

   private SymbolType elementType;

   public ConstantArrayList(List<ConstantValue> list, SymbolType elementType) {
      this.list = list;
      this.elementType = elementType;
   }

   @Override
   public SymbolType getType(ProgramScope scope) {
      return new SymbolTypeArray(elementType);
   }

   public SymbolType getElementType() {
      return elementType;
   }

   public List<ConstantValue> getElements() {
      return list;
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
         out.append(constantValue.toString(program));
      }
      out.append(" }");
      return out.toString();
   }

}
