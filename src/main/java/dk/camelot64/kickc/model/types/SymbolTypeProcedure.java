package dk.camelot64.kickc.model.types;

import java.util.List;
import java.util.Objects;

/** A function returning another type */
public class SymbolTypeProcedure implements SymbolType {

   private SymbolType returnType;
   private List<SymbolType> paramTypes;

   public SymbolTypeProcedure(SymbolType returnType, List<SymbolType> paramTypes) {
      this.returnType = returnType;
      this.paramTypes = paramTypes;
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

   public List<SymbolType> getParamTypes() {
      return paramTypes;
   }

   public void setParamTypes(List<SymbolType> paramTypes) {
      this.paramTypes = paramTypes;
   }

   @Override
   public String getTypeBaseName() {
      final StringBuilder typeBaseName = new StringBuilder();
      typeBaseName.append(returnType.getTypeBaseName());
      typeBaseName.append("(");
      boolean first = true;
      for(SymbolType paramType : paramTypes) {
         if(!first)
            typeBaseName.append(",");
         first = false;
         typeBaseName.append(paramType.getTypeBaseName());
      }
      typeBaseName.append(")");
      return typeBaseName.toString();
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
      return Objects.equals(returnType, that.returnType) &&
            Objects.equals(paramTypes, that.paramTypes);
   }

   @Override
   public int hashCode() {
      return Objects.hash(returnType, paramTypes);
   }

}
