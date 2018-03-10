package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;

/** Unary Decrement operator (--) */
public class OperatorDecrement extends OperatorUnary {

   public OperatorDecrement(int precedence) {
      super("--", "_dec_", precedence);
   }

   @Override
   public ConstantLiteral calculate(ConstantLiteral operand) {
      if(operand instanceof ConstantInteger ) {
         return new ConstantInteger(((ConstantInteger) operand).getInteger() -1);
      }
      throw new CompileError("Not implemented");
   }

}
