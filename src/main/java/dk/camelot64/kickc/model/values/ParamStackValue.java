package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.types.SymbolType;

/** The value passed into a function for a specific parameter using the stack. */
public class ParamStackValue implements RValue {

   /** The constant holding the stack offset of the parameter. */
   private ConstantRef stackOffset;

   /** The type of the value to fetch from the stack. */
   private SymbolType valueType;

   public ParamStackValue(ConstantRef stackOffset, SymbolType valueType) {
      this.stackOffset = stackOffset;
      this.valueType = valueType;
   }

   public ConstantRef getStackOffset() {
      return stackOffset;
   }

   public void setStackOffset(ConstantRef stackOffset) {
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
      return "paramstack("+valueType.getTypeName()+","+stackOffset+")";
   }

}
