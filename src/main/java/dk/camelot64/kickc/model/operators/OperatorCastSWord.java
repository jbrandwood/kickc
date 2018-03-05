package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.OperatorUnary;

/** Unary Cast to signed word operator ( (signed word) x ) */
public class OperatorCastSWord extends OperatorUnary {

   public OperatorCastSWord(int precedence) {
      super("((signed word))", "_sword_", precedence);
   }

}
