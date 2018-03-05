package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.OperatorBinary;

/** Binary greater-than-equal Operator ( x >= y ) */
public class OperatorGreaterThanEqual extends OperatorBinary {

   public OperatorGreaterThanEqual(int precedence) {
      super(">=", "_ge_", precedence);
   }

}
