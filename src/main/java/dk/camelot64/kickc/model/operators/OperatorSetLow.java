package dk.camelot64.kickc.model.operators;

/** Binary SetLowByte Operator ( w lo= b ) */
public class OperatorSetLow extends OperatorBinary {

   public OperatorSetLow(int precedence) {
      super("lo=", "_setlo_", precedence);
   }

}
