package dk.camelot64.kickc.model.types;

import dk.camelot64.kickc.model.symbols.EnumDefinition;

import java.util.Objects;

/** An enum */
public class SymbolTypeEnum implements SymbolType {

   /** Name of the enum type. */
   private String enumName;

   /** The enum definition. */
   private EnumDefinition definition;

   private final boolean isVolatile;
   private final boolean isNomodify;

   public SymbolTypeEnum(EnumDefinition definition, boolean isVolatile, boolean isNomodify) {
      this.definition = definition;
      this.enumName = definition.getLocalName();
      this.isVolatile = isVolatile;
      this.isNomodify = isNomodify;
   }

   public SymbolTypeEnum(String enumName, boolean isVolatile, boolean isNomodify) {
      this.enumName = enumName;
      this.isVolatile = isVolatile;
      this.isNomodify = isNomodify;
   }

   @Override
   public SymbolType getQualified(boolean isVolatile, boolean isNomodify) {
      return new SymbolTypeEnum(this.definition, isVolatile, isNomodify);
   }

   @Override
   public boolean isVolatile() {
      return isVolatile;
   }

   @Override
   public boolean isNomodify() {
      return isNomodify;
   }

   @Override
   public String getTypeBaseName() {
      return  "enum  " + this.enumName;
   }

   @Override
   public int getSizeBytes() {
      return 1;
   }

   public EnumDefinition getDefinition() {
      return definition;
   }

   @Override
   public String toString() {
      return getTypeName();
   }

   @Override
   public boolean equals(Object o) {
      if(this == o) return true;
      if(o == null || getClass() != o.getClass()) return false;
      SymbolTypeEnum that = (SymbolTypeEnum) o;
      return Objects.equals(enumName, that.enumName);
   }

   @Override
   public int hashCode() {
      return Objects.hash(enumName);
   }

   @Override
   public String toCDecl(String parentCDecl) {
      StringBuilder cdecl = new StringBuilder();
      if(isVolatile())
         cdecl.append("volatile ");
      if(isNomodify())
         cdecl.append("const ");
      cdecl.append("enum ");
      cdecl.append(this.enumName);
      cdecl.append(" ");
      cdecl.append(parentCDecl);
      return cdecl.toString();
   }

}
