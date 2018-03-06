package dk.camelot64.kickc.model.operators;

/** Unary Cast to signed word operator ( (signed word) x ) */
public class OperatorCastSWord extends OperatorUnary {

   public OperatorCastSWord(int precedence) {
      super("((signed word))", "_sword_", precedence);
   }

}
