package dk.camelot64.kickc.model.operators;

/** Unary Positive operator (+) */
public class OperatorPos extends OperatorUnary {

   public OperatorPos(int precedence) {
      super("+", "_pos_", precedence);
   }

}
