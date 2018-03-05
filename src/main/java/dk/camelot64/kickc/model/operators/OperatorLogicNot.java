package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.OperatorUnary;

/** Unary Logic Not operator (!b) */
public class OperatorLogicNot extends OperatorUnary {

   public OperatorLogicNot(int precedence) {
      super("!", "_not_", precedence);
   }

}
