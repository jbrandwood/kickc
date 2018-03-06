package dk.camelot64.kickc.model.operators;

/** Unary Cast to byte pointer operator ( (byte*) x ) */
public class OperatorCastPtrByte extends OperatorUnary {

   public OperatorCastPtrByte(int precedence) {
      super("((byte*))", "_ptrby_", precedence);
   }

}
