package dk.camelot64.kickc.model.operators;

/** Binary boolean exclusive or Operator ( x ^ y ) */
public class OperatorBoolXor extends OperatorBinary {

   public OperatorBoolXor(int precedence) {
      super("^", "_bxor_", precedence);
   }

}
