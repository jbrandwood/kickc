package dk.camelot64.kickc.model;

/** A unary expression operator */
public class OperatorUnary extends Operator {
   public OperatorUnary(String operator, String asmOperator, int precedence) {
      super(operator, asmOperator, Type.UNARY, precedence);
   }
}
