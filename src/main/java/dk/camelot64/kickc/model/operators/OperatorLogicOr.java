package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.ConstantBool;
import dk.camelot64.kickc.model.values.ConstantLiteral;

/** Binary logic or Operator ( x || y ) */
public class OperatorLogicOr extends OperatorBinary {

   public OperatorLogicOr(int precedence) {
      super("||", "_or_", precedence, true);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral left, ConstantLiteral right) {
      return new ConstantBool(getBool(left) || getBool(right));
   }

   @Override
   public SymbolType inferType(SymbolType left, SymbolType right) {
      return SymbolType.BOOLEAN;
   }

}
