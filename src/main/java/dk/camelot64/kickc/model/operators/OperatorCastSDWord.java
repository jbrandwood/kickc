package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.OperatorUnary;

/** Unary Cast to signed double word operator ( (signed dword) x ) */
public class OperatorCastSDWord extends OperatorUnary {

   public OperatorCastSDWord(int precedence) {
      super("((signed dword))", "_sdword_", precedence);
   }

}
