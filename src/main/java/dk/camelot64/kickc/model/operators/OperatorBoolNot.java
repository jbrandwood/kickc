package dk.camelot64.kickc.model.operators;

/** Unary Boolean Not operator (~b) */
public class OperatorBoolNot extends OperatorUnary {

   public OperatorBoolNot(int precedence) {
      super("~", "_not_", precedence);
   }

}
