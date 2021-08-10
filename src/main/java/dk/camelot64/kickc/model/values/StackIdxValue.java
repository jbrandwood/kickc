package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.types.SymbolType;

/** The value on the stack at a specific offset from the current stack-pointer. */
public class StackIdxValue implements LValue {

   /** The constant holding the stack offset of the parameter. */
   private ConstantValue stackOffset;

   /** The type of the value to fetch from the stack. */
   private SymbolType valueType;

   public StackIdxValue(ConstantValue stackOffset, SymbolType valueType) {
      this.stackOffset = stackOffset;
      this.valueType = valueType;
   }

   public ConstantValue getStackOffset() {
      return stackOffset;
   }

   public void setStackOffset(ConstantValue stackOffset) {
      this.stackOffset = stackOffset;
   }

   public SymbolType getValueType() {
      return valueType;
   }

   public void setValueType(SymbolType valueType) {
      this.valueType = valueType;
   }

   @Override
   public String toString(Program program) {
      return "stackidx("+ valueType.toCDecl() +","+stackOffset.toString(program)+")";
   }


}
