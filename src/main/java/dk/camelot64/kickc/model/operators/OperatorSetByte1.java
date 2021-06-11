package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.ConstantLiteral;

/** Binary SetByte1 Operator ( w byte1= b ) */
public class OperatorSetByte1 extends OperatorBinary {

   public OperatorSetByte1(int precedence) {
      super("byte1=", "_setbyte1_", precedence, false);
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
