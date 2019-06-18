package dk.camelot64.kickc.model.types;

import dk.camelot64.kickc.model.symbols.EnumDefinition;

import java.util.Objects;

/** An enum */
public class SymbolTypeEnum implements SymbolType {

   /** Name of the enum type. */
   private String name;

   /** The enum definition. */
   private EnumDefinition definition;

   public SymbolTypeEnum(EnumDefinition definition) {
      this.definition = definition;
      this.name = definition.getLocalName();
   }

   @Override
   public String getTypeName() {
      return "enum " + name;
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
      return Objects.equals(name, that.name);
   }

   @Override
   public int hashCode() {
      return Objects.hash(name);
   }

}
