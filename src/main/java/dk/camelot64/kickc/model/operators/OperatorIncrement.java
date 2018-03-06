package dk.camelot64.kickc.model.operators;

/** Unary Increment operator (++) */
public class OperatorIncrement extends OperatorUnary {

   public OperatorIncrement(int precedence) {
      super("++", "_inc_", precedence);
   }

}
