package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.OperatorUnary;

/** Unary Pointer Dereference Operator (*p) */
public class OperatorDeref extends OperatorUnary {

   public OperatorDeref(int precedence) {
      super("*", "_deref_", precedence);
   }

}
