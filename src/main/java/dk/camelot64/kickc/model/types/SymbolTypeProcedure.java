package dk.camelot64.kickc.model.types;

import java.util.List;
import java.util.Objects;
import java.util.StringJoiner;

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
   public String toString() {
      return toCDecl();
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

   @Override
   public String toCDecl(String parentCDecl) {
      final StringBuilder cdecl = new StringBuilder();
      if(parentCDecl.contains("*") || parentCDecl.contains("["))
         cdecl.append("(");
      cdecl.append(parentCDecl);
      if(parentCDecl.contains("*") || parentCDecl.contains("["))
         cdecl.append(")");
      cdecl.append("(");
      StringJoiner joiner = new StringJoiner(", ");
      paramTypes.stream().forEach(symbolType -> joiner.add(symbolType.toCDecl()));
      cdecl.append(joiner);
      cdecl.append(")");
      return getReturnType().toCDecl(cdecl.toString());
   }

   @Override
   public String getConstantFriendlyName() {
      return "PROCEDURE";
   }
}
