package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.OperatorBinary;

/** Binary boolean and Operator ( x & y ) */
public class OperatorBoolAnd extends OperatorBinary {

   public OperatorBoolAnd(int precedence) {
      super("&", "_band_", precedence);
   }

}
