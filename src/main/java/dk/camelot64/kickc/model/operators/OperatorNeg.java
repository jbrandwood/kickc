package dk.camelot64.kickc.model.operators;

/** Unary Negative operator (-) */
public class OperatorNeg extends OperatorUnary {

   public OperatorNeg(int precedence) {
      super("-", "_neg_", precedence);
   }

}
