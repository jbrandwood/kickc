package dk.camelot64.kickc.model.operators;

/** Unary get low operator (<b) */
public class OperatorGetLow extends OperatorUnary {

   public OperatorGetLow(int precedence) {
      super("<", "_lo_", precedence);
   }

}
