package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.OperatorUnary;

/** Unary Cast to double word operator ( (dword) x ) */
public class OperatorCastDWord extends OperatorUnary {

   public OperatorCastDWord(int precedence) {
      super("((dword))", "_dword_", precedence);
   }

}
