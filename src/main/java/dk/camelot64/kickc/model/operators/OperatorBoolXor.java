package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;

/** Binary boolean exclusive or Operator ( x ^ y ) */
public class OperatorBoolXor extends OperatorBinary {

   public OperatorBoolXor(int precedence) {
      super("^", "_bxor_", precedence);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral left, ConstantLiteral right) {
      if(left instanceof ConstantInteger && right instanceof ConstantInteger) {
         return new ConstantInteger(((ConstantInteger) left).getInteger() ^ ((ConstantInteger) right).getInteger());
      }
      throw new CompileError("Not implemented");
   }

}
