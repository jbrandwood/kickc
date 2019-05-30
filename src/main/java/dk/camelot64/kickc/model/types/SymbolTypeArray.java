package dk.camelot64.kickc.model.types;

import dk.camelot64.kickc.model.values.RValue;

/**
 * A fixed size array of another type
 */
public class SymbolTypeArray extends SymbolTypePointer {

   /** The fixed size of the array. Can be null, if the size is not bound. (It will be constant before the compilation is done) */
   private RValue size;

   public SymbolTypeArray(SymbolType elementType, RValue size) {
      super(elementType);
      this.size = size;
   }

   public SymbolTypeArray(SymbolType elementType) {
      super(elementType);
      this.size = null;
   }

   public RValue getSize() {
      return size;
   }

   public void setSize(RValue size) {
      this.size = size;
   }

   @Override
   public String getTypeName() {
      SymbolType elementType = getElementType();
      return elementType.getTypeName() + "[" + (size == null ? "" : size.toString()) + "]";
   }

   @Override
   public boolean equals(Object o) {
      if(this == o) return true;
      if(o == null || getClass() != o.getClass()) return false;
      if(!super.equals(o)) return false;
      SymbolTypeArray that = (SymbolTypeArray) o;
      return size != null ? size.equals(that.size) : that.size == null;
   }

   @Override
   public int hashCode() {
      int result = super.hashCode();
      result = 31 * result + (size != null ? size.hashCode() : 0);
      return result;
   }

   @Override
   public String toString() {
      return getTypeName();
   }

}
