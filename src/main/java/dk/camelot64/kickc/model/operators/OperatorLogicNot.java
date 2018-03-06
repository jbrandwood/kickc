package dk.camelot64.kickc.model.operators;

/** Unary Logic Not operator (!b) */
public class OperatorLogicNot extends OperatorUnary {

   public OperatorLogicNot(int precedence) {
      super("!", "_not_", precedence);
   }

}
