package dk.camelot64.kickc.model.types;

import dk.camelot64.kickc.model.symbols.ArraySpec;

import java.util.Objects;

/** A pointer */
public class SymbolTypePointer implements SymbolType {

   /** The number of bytes needed to represent a pointer in memory. */
   public static final int SIZE_POINTER_BYTES = 2;

   private SymbolType elementType;

   /** If non-null the pointer is an array. */
   private ArraySpec arraySpec;

   public SymbolTypePointer(SymbolType elementType, ArraySpec arraySpec) {
      this.elementType = elementType;
      this.arraySpec = arraySpec;
   }

   public SymbolTypePointer(SymbolType elementType) {
      this(elementType, null);
   }

   public SymbolType getElementType() {
      return elementType;
   }

   public void setElementType(SymbolType elementType) {
      this.elementType = elementType;
   }

   public ArraySpec getArraySpec() {
      return arraySpec;
   }

   @Override
   public String getTypeName() {
      return elementType.getTypeName() + "*";
   }

   @Override
   public int getSizeBytes() {
      return SIZE_POINTER_BYTES;
   }

   @Override
   public boolean equals(Object o) {
      if(this == o) return true;
      if(o == null || getClass() != o.getClass()) return false;
      SymbolTypePointer that = (SymbolTypePointer) o;
      return Objects.equals(elementType, that.elementType);
   }

   @Override
   public int hashCode() {
      return Objects.hash(elementType);
   }

   @Override
   public String toString() {
      return getTypeName();
   }

}
