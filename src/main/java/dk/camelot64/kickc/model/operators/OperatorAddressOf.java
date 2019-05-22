package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.ConstantNotLiteral;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.values.ConstantLiteral;

/** Unary Address-of Operator (&p) */
public class OperatorAddressOf extends OperatorUnary {

   public OperatorAddressOf(int precedence) {
      super("&", "_addr_", precedence);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral operand, ProgramScope scope) {
      throw new ConstantNotLiteral("Constant not literal");
   }

   @Override
   public SymbolType inferType(SymbolType operandType) {
      return new SymbolTypePointer(operandType);
   }
}
