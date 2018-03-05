package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.OperatorBinary;

/** Binary division Operator ( x / y ) */
public class OperatorDivide extends OperatorBinary {

   public OperatorDivide(int precedence) {
      super("/", "_div_", precedence);
   }

}
