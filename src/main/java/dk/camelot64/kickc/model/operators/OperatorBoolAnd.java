package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.values.ConstantBool;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;

/** Binary boolean and Operator ( x & y ) */
public class OperatorBoolAnd extends OperatorBinary {

   public OperatorBoolAnd(int precedence) {
      super("&", "_band_", precedence);
   }

   @Override
   public ConstantLiteral calculate(ConstantLiteral left, ConstantLiteral right) {
      if(left instanceof ConstantInteger && right instanceof ConstantInteger) {
         return new ConstantInteger(((ConstantInteger) left).getInteger() & ((ConstantInteger) right).getInteger());
      }
      throw new CompileError("Not implemented");
   }

}
