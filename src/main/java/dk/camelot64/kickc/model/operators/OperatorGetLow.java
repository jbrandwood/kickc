package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.OperatorUnary;

/** Unary get low operator (<b) */
public class OperatorGetLow extends OperatorUnary {

   public OperatorGetLow(int precedence) {
      super("<", "_lo_", precedence);
   }

}
