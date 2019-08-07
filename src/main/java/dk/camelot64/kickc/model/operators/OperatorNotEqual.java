package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.*;

import java.util.Objects;

/** Binary not-equal Operator ( x != y ) */
public class OperatorNotEqual extends OperatorBinary {

   public OperatorNotEqual(int precedence) {
      super("!=", "_neq_", precedence);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral left, ConstantLiteral right) {
      if(left instanceof ConstantEnumerable && right instanceof ConstantEnumerable) {
         return new ConstantBool(!Objects.equals(((ConstantEnumerable) left).getInteger(), ((ConstantEnumerable) right).getInteger()));
      }
      throw new CompileError("Calculation not implemented " + left + " " + getOperator() + " " + right);
   }

   @Override
   public SymbolType inferType(SymbolType left, SymbolType right) {
      return SymbolType.BOOLEAN;
   }


}
