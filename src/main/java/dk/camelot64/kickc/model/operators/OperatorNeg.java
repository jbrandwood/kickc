package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.OperatorUnary;

/** Unary Negative operator (-) */
public class OperatorNeg extends OperatorUnary {

   public OperatorNeg(int precedence) {
      super("-", "_neg_", precedence);
   }

}
