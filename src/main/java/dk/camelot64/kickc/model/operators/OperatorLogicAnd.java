package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.ConstantBool;
import dk.camelot64.kickc.model.values.ConstantLiteral;

/** Binary logic and Operator ( x && y ) */
public class OperatorLogicAnd extends OperatorBinary {

   public OperatorLogicAnd(int precedence) {
      super("&&", "_and_", precedence, true);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral left, ConstantLiteral right) {
      if(left instanceof ConstantBool && right instanceof ConstantBool) {
         return new ConstantBool(((ConstantBool) left).getBool() && ((ConstantBool) right).getBool());
      }
      throw new CompileError("Calculation not implemented " + left + " " + getOperator() + " " + right);
   }

   @Override
   public SymbolType inferType(SymbolType left, SymbolType right) {
      return SymbolType.BOOLEAN;
   }


}
