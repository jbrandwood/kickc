package dk.camelot64.kickc.icl;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;

/** A pointer */
public class SymbolTypePointer implements SymbolType {

   private SymbolType elementType;

   @JsonCreator
   public SymbolTypePointer(
         @JsonProperty("elementType") SymbolType elementType) {
      this.elementType = elementType;
   }

   public SymbolType getElementType() {
      return elementType;
   }

   public void setElementType(SymbolType elementType) {
      this.elementType = elementType;
   }

   @Override
   @JsonIgnore
   public String getTypeName() {
      return elementType.getTypeName()+"*";
   }

   @Override
   public boolean equals(Object o) {
      if (this == o) {
         return true;
      }
      if (o == null || getClass() != o.getClass()) {
         return false;
      }

      SymbolTypePointer that = (SymbolTypePointer) o;

      return elementType != null ? elementType.equals(that.elementType) : that.elementType == null;
   }

   @Override
   public int hashCode() {
      return elementType != null ? elementType.hashCode() : 0;
   }
}
