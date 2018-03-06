package dk.camelot64.kickc.model.operators;

/** Binary division Operator ( x / y ) */
public class OperatorDivide extends OperatorBinary {

   public OperatorDivide(int precedence) {
      super("/", "_div_", precedence);
   }

}
