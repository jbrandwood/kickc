package dk.camelot64.kickc.model.operators;

/** Unary Cast to double word operator ( (dword) x ) */
public class OperatorCastDWord extends OperatorUnary {

   public OperatorCastDWord(int precedence) {
      super("((dword))", "_dword_", precedence);
   }

}
