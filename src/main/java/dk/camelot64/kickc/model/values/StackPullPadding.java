package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.Program;

/** Pulls a number of padding bytes from the stack. */
public class StackPullPadding implements RValue {

   /** The number of padding bytes. */
   private ConstantValue size;

   public StackPullPadding(ConstantValue size) {
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
      return "stackpullpadding(" + size.toString(program)+ ")";
   }
}
