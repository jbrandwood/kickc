package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;

/** Unary Positive operator (+) */
public class OperatorPos extends OperatorUnary {

   public OperatorPos(int precedence) {
      super("+", "_pos_", precedence);
   }

   @Override
   public ConstantLiteral calculate(ConstantLiteral operand) {
      if(operand instanceof ConstantInteger) {
         return new ConstantInteger(+((ConstantInteger)operand).getInteger());
      }
      throw new CompileError("Not implemented");
   }

}
