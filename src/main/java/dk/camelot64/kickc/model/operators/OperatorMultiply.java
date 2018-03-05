package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.OperatorBinary;

/** Binary multiply Operator ( x * y ) */
public class OperatorMultiply extends OperatorBinary {

   public OperatorMultiply(int precedence) {
      super("*", "_mul_", precedence);
   }

}
