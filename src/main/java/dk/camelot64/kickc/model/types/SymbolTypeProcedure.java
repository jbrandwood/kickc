package dk.camelot64.kickc.model.types;

import java.util.Objects;

/** A function returning another type */
public class SymbolTypeProcedure implements SymbolType {

   private SymbolType returnType;

   public SymbolTypeProcedure(SymbolType returnType) {
      this.returnType = returnType;
   }

   @Override
   public SymbolType getQualified(boolean isVolatile, boolean isNomodify) {
      return this;
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
   public int getSizeBytes() {
      return -1;
   }

   public SymbolType getReturnType() {
      return returnType;
   }

   @Override
   public String getTypeName() {
      return returnType.getTypeName() + "()";
   }

   @Override
   public String toString() {
      return getTypeName();
   }

   @Override
   public boolean equals(Object o) {
      if(this == o) return true;
      if(o == null || getClass() != o.getClass()) return false;
      SymbolTypeProcedure that = (SymbolTypeProcedure) o;
      return Objects.equals(returnType, that.returnType);
   }

   @Override
   public int hashCode() {
      return Objects.hash(returnType);
   }
}
