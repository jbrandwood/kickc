package dk.camelot64.kickc.model.operators;

/** Binary SetHighByte Operator ( w hi= b ) */
public class OperatorSetHigh extends OperatorBinary {

   public OperatorSetHigh(int precedence) {
      super("hi=", "_sethi_", precedence);
   }

}
