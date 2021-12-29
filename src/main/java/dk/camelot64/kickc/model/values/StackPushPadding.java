package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.Program;

/** Pushes a number of padding bytes to the stack. */
public class StackPushPadding implements RValue {

   /** The number of padding bytes. */
   private ConstantValue size;

   public StackPushPadding(ConstantValue size) {
      this.size = size;
   }

   public ConstantValue getSize() {
      return size;
   }

   public void setSize(ConstantValue size) {
      this.size = size;
   }

   @Override
   public String toString(Program program) {
      return "stackpushpadding(" + size.toString(program)+ ")";
   }
}
