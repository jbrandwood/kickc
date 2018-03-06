package dk.camelot64.kickc.model.operators;

/** Unary Cast to byte operator ( (byte) x ) */
public class OperatorCastByte extends OperatorUnary {

   public OperatorCastByte(int precedence) {
      super("((byte))", "_byte_", precedence);
   }

}
