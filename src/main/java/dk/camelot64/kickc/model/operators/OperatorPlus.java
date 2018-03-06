package dk.camelot64.kickc.model.operators;

/** Binary plus Operator ( x + y ) */
public class OperatorPlus extends OperatorBinary {

   public OperatorPlus(int precedence) {
      super("+", "_plus_", precedence);
   }

}
