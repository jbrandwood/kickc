package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.ConstantNotLiteral;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.types.SymbolTypeSimple;
import dk.camelot64.kickc.model.values.ConstantLiteral;

/** Unary Address-of Operator (&p) */
public class OperatorAddressOf extends OperatorUnary {

   public OperatorAddressOf(int precedence) {
      super("&", "_addr_", precedence);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral operand) {
      throw new ConstantNotLiteral("Constant not literal");
   }

   @Override
   public SymbolType inferType(SymbolTypeSimple operandType) {
      return new SymbolTypePointer(operandType);
   }
}
