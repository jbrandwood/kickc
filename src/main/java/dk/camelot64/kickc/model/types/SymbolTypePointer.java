package dk.camelot64.kickc.model.types;

/** A pointer */
public class SymbolTypePointer implements SymbolTypeSimple {

   /** The number of bytes needed to represent a pointer in memory. */
   public static final int SIZE_BYTES = 2;

   private SymbolType elementType;

   public SymbolTypePointer(
         SymbolType elementType) {
      this.elementType = elementType;
   }

   public SymbolType getElementType() {
      return elementType;
   }

   public void setElementType(SymbolType elementType) {
      this.elementType = elementType;
   }

   @Override
   public String getTypeName() {
      return elementType.getTypeName() + "*";
   }

   @Override
   public int getSizeBytes() {
      return SIZE_BYTES;
   }

   @Override
   public boolean equals(Object o) {
      if(this == o) {
         return true;
      }
      if(o == null || getClass() != o.getClass()) {
         return false;
      }
      SymbolTypePointer that = (SymbolTypePointer) o;
      return elementType != null ? elementType.equals(that.elementType) : that.elementType == null;
   }

   @Override
   public int hashCode() {
      return elementType != null ? elementType.hashCode() : 0;
   }

   @Override
   public String toString() {
      return getTypeName();
   }

}
