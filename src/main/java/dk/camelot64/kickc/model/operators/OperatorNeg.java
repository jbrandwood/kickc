package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;

/** Unary Negative operator (-) */
public class OperatorNeg extends OperatorUnary {

   public OperatorNeg(int precedence) {
      super("-", "_neg_", precedence);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral operand) {
      if(operand instanceof ConstantInteger) {
         return new ConstantInteger(-((ConstantInteger)operand).getInteger());
      }
      throw new CompileError("Not implemented");
   }
}
