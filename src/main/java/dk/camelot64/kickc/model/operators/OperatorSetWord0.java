package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.ConstantLiteral;

/** Binary SetWord0 Operator ( w word0= b ) */
public class OperatorSetWord0 extends OperatorBinary {

   public OperatorSetWord0(int precedence) {
      super("word0=", "_setword0_", precedence, false);
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
