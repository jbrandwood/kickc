package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.Program;

/** Pushes a number og bytes to the stack. */
public class StackPushBytes implements RValue {

   /** The type of value being pushed. */
   private ConstantValue bytes;

   public StackPushBytes(ConstantValue bytes) {
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
      return "stackpushbytes(" + bytes.toString(program)+ ")";
   }
}
