package dk.camelot64.kickc.icl;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;

/** A fixed size array of another type */
public class SymbolTypeArray extends SymbolTypePointer {

   private int size;

   @JsonCreator
   public SymbolTypeArray(
         @JsonProperty("elementType") SymbolType elementType,
         @JsonProperty("size") int size) {
      super(elementType);
      this.size = size;
   }

   public int getSize() {
      return size;
   }

   public void setSize(int size) {
      this.size = size;
   }

   @Override
   public String getTypeName() {
      return getElementType().getTypeName()+"["+size+"]";
   }

   @Override
   public boolean equals(Object o) {
      if (this == o) {
         return true;
      }
      if (o == null || getClass() != o.getClass()) {
         return false;
      }
      if (!super.equals(o)) {
         return false;
      }

      SymbolTypeArray that = (SymbolTypeArray) o;

      return size == that.size;
   }

   @Override
   public int hashCode() {
      int result = super.hashCode();
      result = 31 * result + size;
      return result;
   }
}
