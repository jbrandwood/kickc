package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;

/** Unary Cast to signed byte operator ( (signed byte) x ) */
public class OperatorCastSByte extends OperatorUnary {

   public OperatorCastSByte(int precedence) {
      super("((signed byte))", "_sbyte_", precedence);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral value) {
      if(value instanceof ConstantInteger) {
         return new ConstantInteger(0xff & ((ConstantInteger) value).getValue());
      }
      throw new CompileError("Not implemented");
   }

}
