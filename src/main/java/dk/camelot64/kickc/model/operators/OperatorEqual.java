package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.OperatorBinary;

/** Binary equal Operator ( x == y ) */
public class OperatorEqual extends OperatorBinary {

   public OperatorEqual(int precedence) {
      super("==", "_eq_", precedence);
   }

}
