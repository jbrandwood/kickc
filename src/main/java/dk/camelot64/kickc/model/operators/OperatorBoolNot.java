package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.OperatorUnary;

/** Unary Boolean Not operator (~b) */
public class OperatorBoolNot extends OperatorUnary {

   public OperatorBoolNot(int precedence) {
      super("~", "_not_", precedence);
   }

}
