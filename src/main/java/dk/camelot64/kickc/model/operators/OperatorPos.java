package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.OperatorUnary;

/** Unary Positive operator (+) */
public class OperatorPos extends OperatorUnary {

   public OperatorPos(int precedence) {
      super("+", "_pos_", precedence);
   }

}
