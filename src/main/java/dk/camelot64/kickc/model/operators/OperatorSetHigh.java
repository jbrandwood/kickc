package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.OperatorBinary;

/** Binary SetHighByte Operator ( w hi= b ) */
public class OperatorSetHigh extends OperatorBinary {

   public OperatorSetHigh(int precedence) {
      super("hi=", "_sethi_", precedence);
   }

}
