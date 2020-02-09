package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.types.SymbolType;

/** Value representing intrinsic call to memset(dest, 0, size). */
public class MemsetValue implements RValue {

   /** The constant holding the size to set to zero. */
   private ConstantValue size;

   /** The type of the value. */
   private SymbolType type;

   public MemsetValue(ConstantValue size, SymbolType type) {
      this.size = size;
      this.type = type;
   }

   public ConstantValue getSize() {
      return size;
   }

   public void setSize(ConstantValue size) {
      this.size = size;
   }

   public SymbolType getType() {
      return type;
   }

   @Override
   public String toString(Program program) {
      return "memset("+type.getTypeName()+", "+size.toString(program)+")";
   }


}
