package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.OperatorUnary;

/** Unary Increment operator (++) */
public class OperatorIncrement extends OperatorUnary {

   public OperatorIncrement(int precedence) {
      super("++", "_inc_", precedence);
   }

}
