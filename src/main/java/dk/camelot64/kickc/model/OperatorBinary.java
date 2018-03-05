package dk.camelot64.kickc.model;

/** A binary expression operator */
public class OperatorBinary extends Operator {
   public OperatorBinary(String operator, String asmOperator, int precedence) {
      super(operator, asmOperator, Type.BINARY, precedence);
   }
}
