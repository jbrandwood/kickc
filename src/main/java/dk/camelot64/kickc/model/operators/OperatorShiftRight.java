package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.OperatorBinary;

/** Binary shift right Operator ( x >> n ) */
public class OperatorShiftRight extends OperatorBinary {

   public OperatorShiftRight(int precedence) {
      super(">>", "_ror_", precedence);
   }

}
