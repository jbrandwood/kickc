package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.Program;

/** The value passed into a function for a specific parameter using the stack. */
public class ParamStackValue implements RValue {

   /** The constant holding the stack offset of the parameter. */
   private ConstantRef stackOffset;

   public ParamStackValue(ConstantRef stackOffset) {
      this.stackOffset = stackOffset;
   }

   public ConstantRef getStackOffset() {
      return stackOffset;
   }

   public void setStackOffset(ConstantRef stackOffset) {
      this.stackOffset = stackOffset;
   }

   @Override
   public String toString(Program program) {
      return "paramstack("+stackOffset+")";
   }

}
