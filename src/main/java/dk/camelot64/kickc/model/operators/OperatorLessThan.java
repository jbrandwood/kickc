package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.values.ConstantBool;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;

/** Binary less-than Operator ( x < y ) */
public class OperatorLessThan extends OperatorBinary {

   public OperatorLessThan(int precedence) {
      super("<", "_lt_", precedence);
   }

   @Override
   public ConstantLiteral calculate(ConstantLiteral left, ConstantLiteral right) {
      if(left instanceof ConstantInteger && right instanceof ConstantInteger) {
         return new ConstantBool(((ConstantInteger) left).getInteger() < ((ConstantInteger) right).getInteger());
      }
      throw new CompileError("Not implemented");
   }

}
