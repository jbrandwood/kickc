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
   public String getTypeName() {
      String name = "";

      // TODO #121 Add
      /*
      if(isVolatile)
         name += "volatile ";
      if(isNomodify)
         name += "const ";
      */
      name += "enum  " + this.enumName;
      return name;
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

}
