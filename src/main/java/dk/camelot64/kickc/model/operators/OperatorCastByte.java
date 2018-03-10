package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;
import dk.camelot64.kickc.model.values.ConstantPointer;

/** Unary Cast to byte operator ( (byte) x ) */
public class OperatorCastByte extends OperatorUnary {

   public OperatorCastByte(int precedence) {
      super("((byte))", "_byte_", precedence);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral value) {
      if(value instanceof ConstantInteger) {
         return new ConstantInteger(0xff & ((ConstantInteger) value).getValue());
      } else if(value instanceof ConstantPointer) {
         return new ConstantInteger(((ConstantPointer) value).getLocation()&0xff);
      }
      throw new CompileError("Not implemented");
   }

}
