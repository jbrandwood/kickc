package dk.camelot64.kickc.model.operators;

/** Unary get high operator (>b) */
public class OperatorGetHigh extends OperatorUnary {

   public OperatorGetHigh(int precedence) {
      super(">", "_hi_", precedence);
   }

}
