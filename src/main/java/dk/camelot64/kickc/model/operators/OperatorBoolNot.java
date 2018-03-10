package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;

/** Unary Boolean Not operator (~b) */
public class OperatorBoolNot extends OperatorUnary {

   public OperatorBoolNot(int precedence) {
      super("~", "_not_", precedence);
   }

   @Override
   public ConstantLiteral calculate(ConstantLiteral left) {
      if(left instanceof ConstantInteger) {
         return new ConstantInteger(~((ConstantInteger) left).getInteger());
      }
      throw new CompileError("Not implemented");
   }
}
