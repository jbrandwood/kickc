package dk.camelot64.kickc.model.types;

import java.util.Objects;

/** Integer type that has not yet been fixed. This is used for constant expressions. The type is fixed when the constant meets a fixed type. */
public class SymbolTypeIntegerAuto implements SymbolTypeInteger {

   private final String typeName;

   SymbolTypeIntegerAuto(String typeName) {
      this.typeName = typeName;
   }

   @Override
   public boolean isVolatile() {
      return false;
   }

   @Override
   public boolean isNomodify() {
      return false;
   }

   @Override
   public String getTypeName() {
      return typeName;
   }

   @Override
   public int getSizeBytes() {
      return -1;
   }

   @Override
   public String toString() {
      return getTypeName();
   }

   @Override
   public boolean equals(Object o) {
      if(this == o) return true;
      if(o == null || getClass() != o.getClass()) return false;
      SymbolTypeIntegerAuto that = (SymbolTypeIntegerAuto) o;
      return Objects.equals(typeName, that.typeName);
   }

   @Override
   public int hashCode() {
      return Objects.hash(typeName);
   }
}
