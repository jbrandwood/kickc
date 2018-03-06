package dk.camelot64.kickc.model.operators;

/** Binary boolean and Operator ( x & y ) */
public class OperatorBoolAnd extends OperatorBinary {

   public OperatorBoolAnd(int precedence) {
      super("&", "_band_", precedence);
   }

}
