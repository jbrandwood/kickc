package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.OperatorBinary;

/** Binary shift left Operator ( x << n ) */
public class OperatorShiftLeft extends OperatorBinary {

   public OperatorShiftLeft(int precedence) {
      super("<<", "_rol_", precedence);
   }

}
