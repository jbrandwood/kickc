package dk.camelot64.kickc.icl;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;

/** A fixed size array of another type */
public class SymbolTypeArray extends SymbolTypePointer {

   /** The fixed size of the array. Can by null, if the type is not known yet. (It will be constant before the compilation is done) */
   private Integer size;

   @JsonCreator
   public SymbolTypeArray(
         @JsonProperty("elementType") SymbolType elementType,
         @JsonProperty("size") int size) {
      super(elementType);
      this.size = size;
   }

   public SymbolTypeArray(SymbolType elementType) {
      super(elementType);
      this.size = null;
   }

   public int getSize() {
      return size;
   }

   public void setSize(Integer size) {
      this.size = size;
   }

   @Override
   public String getTypeName() {
      return getElementType().getTypeName()+"["+(size==null?"":size)+"]";
   }

   @Override
   public boolean equals(Object o) {
      if (this == o) return true;
      if (o == null || getClass() != o.getClass()) return false;
      if (!super.equals(o)) return false;

      SymbolTypeArray that = (SymbolTypeArray) o;

      return size != null ? size.equals(that.size) : that.size == null;
   }

   @Override
   public int hashCode() {
      int result = super.hashCode();
      result = 31 * result + (size != null ? size.hashCode() : 0);
      return result;
   }
}
