package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.ConstantLiteral;

/** Binary SetWord1 Operator ( w word1= b ) */
public class OperatorSetWord1 extends OperatorBinary {

   public OperatorSetWord1(int precedence) {
      super("word1=", "_setword1_", precedence, false);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral left, ConstantLiteral right) {
      throw new CompileError("Calculation not implemented " + left + " " + getOperator() + " " + right);
   }

   @Override
   public SymbolType inferType(SymbolType left, SymbolType right) {
      return left;
   }

}
