package dk.camelot64.kickc.icl;

/** A fixed size array of another type */
public class SymbolTypeArray implements SymbolType {

   private SymbolType elementType;
   private int size;

   public SymbolTypeArray(SymbolType elementType, int size) {
      this.elementType = elementType;
      this.size = size;
   }

   public SymbolType getElementType() {
      return elementType;
   }

   public int getSize() {
      return size;
   }

   @Override
   public String getTypeName() {
      return elementType.getTypeName()+"["+size+"]";
   }
}
