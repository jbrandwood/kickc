package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.OperatorUnary;

/** Unary Decrement operator (--) */
public class OperatorDecrement extends OperatorUnary {

   public OperatorDecrement(int precedence) {
      super("--", "_dec_", precedence);
   }

}
