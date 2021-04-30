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

   private final boolean isVolatile;
   private final boolean isNomodify;

   public SymbolTypePointer(SymbolType elementType, ArraySpec arraySpec, boolean isVolatile, boolean isNomodify) {
      this.elementType = elementType;
      this.arraySpec = arraySpec;
      this.isVolatile = isVolatile;
      this.isNomodify = isNomodify;
   }

   public SymbolTypePointer(SymbolType elementType) {
      this(elementType, null, false, false);
   }

   @Override
   public SymbolType getQualified(boolean isVolatile, boolean isNomodify) {
      return new SymbolTypePointer(this.elementType, this.arraySpec, isVolatile, isNomodify);
   }

   @Override
   public boolean isVolatile() {
      return isVolatile;
   }

   @Override
   public boolean isNomodify() {
      return isNomodify;
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
      String name = elementType.getTypeName() + "*";
      if(isVolatile)
         name += " volatile";
      if(isNomodify)
         name += " const";
      return name;
   }

   @Override
   public String getTypeBaseName() {
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
