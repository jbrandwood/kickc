package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.values.ConstantLiteral;

/** Unary Address-of Operator (&p) */
public class OperatorAddressOf extends OperatorUnary {

   public OperatorAddressOf(int precedence) {
      super("&", "_addr_", precedence);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral operand) {
      throw new CompileError("Not implemented");
   }

}
