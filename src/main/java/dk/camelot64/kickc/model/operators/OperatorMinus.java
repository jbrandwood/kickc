package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;

/** Binary minus Operator ( x - y ) */
public class OperatorMinus extends OperatorBinary {

   public OperatorMinus(int precedence) {
      super("-", "_minus_", precedence);
   }

   @Override
   public ConstantLiteral calculate(ConstantLiteral left, ConstantLiteral right) {
      if(left instanceof ConstantInteger && right instanceof ConstantInteger) {
         return new ConstantInteger(((ConstantInteger) left).getInteger() - ((ConstantInteger) right).getInteger());
      }
      throw new CompileError("Not implemented");
   }

}
