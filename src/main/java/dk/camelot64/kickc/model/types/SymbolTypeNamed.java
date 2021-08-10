package dk.camelot64.kickc.model.types;

import java.util.Locale;

/** Basic named (string, char, ...) Symbol Types */
public class SymbolTypeNamed implements SymbolType {

   private String typeName;
   private int sizeBytes;
   private final boolean isVolatile;
   private final boolean isNomodify;

   SymbolTypeNamed(String typeName, int sizeBytes, boolean isVolatile, boolean isNomodify) {
      this.typeName = typeName;
      this.sizeBytes = sizeBytes;
      this.isVolatile = isVolatile;
      this.isNomodify = isNomodify;
   }

   @Override
   public SymbolType getQualified(boolean isVolatile, boolean isNomodify) {
      return new SymbolTypeNamed(this.typeName, this.sizeBytes, isVolatile, isNomodify);
   }

   @Override
   public boolean isVolatile() {
      return isVolatile;
   }

   @Override
   public boolean isNomodify() {
      return isNomodify;
   }

   public String getTypeName() {
      return typeName;
   }

   @Override
   public int getSizeBytes() {
      return sizeBytes;
   }

   @Override
   public boolean equals(Object o) {
      if(this == o) {
         return true;
      }
      if(o == null || getClass() != o.getClass()) {
         return false;
      }

      SymbolTypeNamed that = (SymbolTypeNamed) o;

      return typeName != null ? typeName.equals(that.typeName) : that.typeName == null;
   }

   @Override
   public int hashCode() {
      return typeName != null ? typeName.hashCode() : 0;
   }

   @Override
   public String toString() {
      return toCDecl();
   }

   @Override
   public String toCDecl(String parentCDecl) {
      StringBuilder cdecl = new StringBuilder();
      if(isVolatile())
         cdecl.append("volatile ");
      if(isNomodify())
         cdecl.append("const ");
      cdecl.append(this.typeName);
      if(parentCDecl.length()>0)
         cdecl.append(" ");
      cdecl.append(parentCDecl);
      return cdecl.toString();
   }

   @Override
   public String getConstantFriendlyName() {
         return typeName.toUpperCase(Locale.ENGLISH).replace(" ", "_");
   }

}

