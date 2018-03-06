package dk.camelot64.kickc.model.operators;

/** Unary Decrement operator (--) */
public class OperatorDecrement extends OperatorUnary {

   public OperatorDecrement(int precedence) {
      super("--", "_dec_", precedence);
   }

}
