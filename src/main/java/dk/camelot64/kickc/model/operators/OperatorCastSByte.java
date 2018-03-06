package dk.camelot64.kickc.model.operators;

/** Unary Cast to signed byte operator ( (signed byte) x ) */
public class OperatorCastSByte extends OperatorUnary {

   public OperatorCastSByte(int precedence) {
      super("((signed byte))", "_sbyte_", precedence);
   }

}
