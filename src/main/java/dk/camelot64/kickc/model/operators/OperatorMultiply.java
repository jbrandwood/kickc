package dk.camelot64.kickc.model.operators;

/** Binary multiply Operator ( x * y ) */
public class OperatorMultiply extends OperatorBinary {

   public OperatorMultiply(int precedence) {
      super("*", "_mul_", precedence);
   }

}
