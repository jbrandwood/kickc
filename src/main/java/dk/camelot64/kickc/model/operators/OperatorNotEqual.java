package dk.camelot64.kickc.model.operators;

/** Binary not-equal Operator ( x != y ) */
public class OperatorNotEqual extends OperatorBinary {

   public OperatorNotEqual(int precedence) {
      super("!=", "_neq_", precedence);
   }

}
