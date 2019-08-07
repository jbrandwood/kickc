package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.ConstantBool;
import dk.camelot64.kickc.model.values.ConstantEnumerable;
import dk.camelot64.kickc.model.values.ConstantLiteral;

import java.util.Objects;

/** Binary equal Operator ( x == y ) */
public class OperatorEqual extends OperatorBinary {

   public OperatorEqual(int precedence) {
      super("==", "_eq_", precedence);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral left, ConstantLiteral right) {
      if(left instanceof ConstantEnumerable && right instanceof ConstantEnumerable) {
         return new ConstantBool(Objects.equals(((ConstantEnumerable) left).getInteger(), ((ConstantEnumerable) right).getInteger()));
      }
      throw new CompileError("Calculation not implemented " + left + " " + getOperator() + " " + right);
   }

   @Override
   public SymbolType inferType(SymbolType left, SymbolType right) {
      return SymbolType.BOOLEAN;
   }

}
