package dk.camelot64.kickc.model.operators;

/** Binary minus Operator ( x - y ) */
public class OperatorMinus extends OperatorBinary {

   public OperatorMinus(int precedence) {
      super("-", "_minus_", precedence);
   }

}
