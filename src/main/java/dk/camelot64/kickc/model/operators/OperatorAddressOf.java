package dk.camelot64.kickc.model.operators;

/** Unary Address-of Operator (&p) */
public class OperatorAddressOf extends OperatorUnary {

   public OperatorAddressOf(int precedence) {
      super("&", "_addr_", precedence);
   }

}
