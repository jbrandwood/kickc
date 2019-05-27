package dk.camelot64.kickc.model.types;

import dk.camelot64.kickc.model.symbols.StructDefinition;
import dk.camelot64.kickc.model.symbols.Variable;

import java.util.Objects;

/** A struct */
public class SymbolTypeStruct implements SymbolType {

   /** Name of the struct type. */
   private String name;

   /** Size of the struct in bytes. */
   private int sizeBytes;

   public SymbolTypeStruct(StructDefinition structDefinition) {
      this.name = structDefinition.getLocalName();
      int sizeBytes = 0;
      for(Variable member : structDefinition.getAllVariables(false)) {
         sizeBytes += member.getType().getSizeBytes();
      }
      this.sizeBytes = sizeBytes;
   }

   @Override
   public String getTypeName() {
      return "struct " + name;
   }

   public String getStructTypeName() {
      return name;
   }

   @Override
   public int getSizeBytes() {
      return sizeBytes;
   }

   @Override
   public boolean equals(Object o) {
      if(this == o) return true;
      if(o == null || getClass() != o.getClass()) return false;
      SymbolTypeStruct that = (SymbolTypeStruct) o;
      return sizeBytes == that.sizeBytes &&
            Objects.equals(name, that.name);
   }

   @Override
   public int hashCode() {

      return Objects.hash(name, sizeBytes);
   }

   @Override
   public String toString() {
      return getTypeName();
   }

}
