package dk.camelot64.kickc.model.operators;

/** Unary Cast to word operator ( (word) x ) */
public class OperatorCastWord extends OperatorUnary {

   public OperatorCastWord(int precedence) {
      super("((word))", "_word_", precedence);
   }

}
