package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.ConstantBool;
import dk.camelot64.kickc.model.values.ConstantLiteral;

/** Unary Logic Not operator (!b) */
public class OperatorLogicNot extends OperatorUnary {

   public OperatorLogicNot(int precedence) {
      super("!", "_not_", precedence);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral left, ProgramScope scope) {
      return new ConstantBool(!getBool(left));
   }

   @Override
   public SymbolType inferType(SymbolType operandType) {
      return SymbolType.BOOLEAN;
   }

}
