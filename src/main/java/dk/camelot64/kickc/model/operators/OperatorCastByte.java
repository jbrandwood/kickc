package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.OperatorUnary;

/** Unary Cast to byte operator ( (byte) x ) */
public class OperatorCastByte extends OperatorUnary {

   public OperatorCastByte(int precedence) {
      super("((byte))", "_byte_", precedence);
   }

}
