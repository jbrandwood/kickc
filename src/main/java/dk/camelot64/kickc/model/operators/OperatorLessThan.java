package dk.camelot64.kickc.model.operators;

/** Binary less-than Operator ( x < y ) */
public class OperatorLessThan extends OperatorBinary {

   public OperatorLessThan(int precedence) {
      super("<", "_lt_", precedence);
   }

}
