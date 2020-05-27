package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.ConstantBool;
import dk.camelot64.kickc.model.values.ConstantEnumerable;
import dk.camelot64.kickc.model.values.ConstantLiteral;

/** Binary less-than Operator ( x < y ) */
public class OperatorLessThan extends OperatorBinary {

   public OperatorLessThan(int precedence) {
      super("<", "_lt_", precedence, false);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral left, ConstantLiteral right) {
      if(left instanceof ConstantEnumerable && right instanceof ConstantEnumerable) {
         return new ConstantBool(((ConstantEnumerable) left).getInteger() < ((ConstantEnumerable) right).getInteger());
      }
      throw new CompileError("Calculation not implemented " + left + " " + getOperator() + " " + right);
   }

   @Override
   public SymbolType inferType(SymbolType left, SymbolType right) {
      return SymbolType.BOOLEAN;
   }


}
