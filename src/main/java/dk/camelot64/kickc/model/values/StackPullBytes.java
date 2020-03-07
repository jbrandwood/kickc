package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.Program;

/** Pulls a number og bytes from the stack. */
public class StackPullBytes implements RValue {

   /** The type of value being pushed. */
   private ConstantValue bytes;

   public StackPullBytes(ConstantValue bytes) {
      this.bytes = bytes;
   }

   public ConstantValue getBytes() {
      return bytes;
   }

   public void setBytes(ConstantValue bytes) {
      this.bytes = bytes;
   }

   @Override
   public String toString(Program program) {
      return "stackpullbytes(" + bytes.toString(program)+ ")";
   }
}
