package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.Program;

/** Value representing intrinsic call to memcpy(dest, src, size). */
public class MemcpyValue implements RValue {

   /** The pointer dereference to copy from. */
   private RValue source;

   /** The constant holding the size to set to zero. */
   private ConstantValue size;

   public MemcpyValue(RValue source, ConstantValue size) {
      this.source = source;
      this.size = size;
   }

   public ConstantValue getSize() {
      return size;
   }

   public void setSize(ConstantValue size) {
      this.size = size;
   }

   public RValue getSource() {
      return source;
   }

   public void setSource(RValue source) {
      this.source = source;
   }

   @Override
   public String toString(Program program) {
      return "memcpy("+source.toString(program)+", "+size.toString(program)+")";
   }


}
