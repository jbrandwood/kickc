package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.OperatorBinary;

/** Binary less-than-equal Operator ( x <= y ) */
public class OperatorLessThanEqual extends OperatorBinary {

   public OperatorLessThanEqual(int precedence) {
      super("<=", "_le_", precedence);
   }

}
