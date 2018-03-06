package dk.camelot64.kickc.model.operators;

/** Binary Word Constructor operator (b w= b) */
public class OperatorWord extends OperatorBinary {

   public OperatorWord(int precedence) {
      super("w=", "_word_", precedence);
   }

}
