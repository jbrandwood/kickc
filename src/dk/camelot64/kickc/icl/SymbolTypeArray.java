package dk.camelot64.kickc.icl;

/** A fixed size array of another type */
public class SymbolTypeArray extends SymbolTypePointer {

   private int size;

   public SymbolTypeArray(SymbolType elementType, int size) {
      super(elementType);
      this.size = size;
   }

   public int getSize() {
      return size;
   }

   @Override
   public String getTypeName() {
      return getElementType().getTypeName()+"["+size+"]";
   }
}
