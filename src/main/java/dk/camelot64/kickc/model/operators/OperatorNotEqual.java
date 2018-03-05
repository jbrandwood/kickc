package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.OperatorBinary;

/** Binary not-equal Operator ( x != y ) */
public class OperatorNotEqual extends OperatorBinary {

   public OperatorNotEqual(int precedence) {
      super("!=", "_neq_", precedence);
   }

}
