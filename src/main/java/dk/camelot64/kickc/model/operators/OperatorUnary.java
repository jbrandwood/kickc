package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.values.ConstantLiteral;

/** A unary expression operator */
public abstract class OperatorUnary extends Operator {

   public OperatorUnary(String operator, String asmOperator, int precedence) {
      super(operator, asmOperator, Type.UNARY, precedence);
   }

   public abstract ConstantLiteral calculate(ConstantLiteral operand);
}
