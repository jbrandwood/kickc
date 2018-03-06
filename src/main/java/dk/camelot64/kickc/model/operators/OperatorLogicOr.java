package dk.camelot64.kickc.model.operators;

/** Binary logic or Operator ( x || y ) */
public class OperatorLogicOr extends OperatorBinary {

   public OperatorLogicOr(int precedence) {
      super("||", "_or_", precedence);
   }

}
