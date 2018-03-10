package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.values.ConstantLiteral;

/** A binary expression operator */
public abstract class OperatorBinary extends Operator {

   public OperatorBinary(String operator, String asmOperator, int precedence) {
      super(operator, asmOperator, Type.BINARY, precedence);
   }

   public abstract ConstantLiteral calculate(ConstantLiteral left, ConstantLiteral right);

}
