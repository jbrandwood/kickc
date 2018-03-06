package dk.camelot64.kickc.model.operators;

/** Binary boolean or Operator ( x | y ) */
public class OperatorBoolOr extends OperatorBinary {

   public OperatorBoolOr(int precedence) {
      super("|", "_bor_", precedence);
   }

}
