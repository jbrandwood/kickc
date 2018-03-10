package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.values.ConstantLiteral;

/** Binary SetHighByte Operator ( w hi= b ) */
public class OperatorSetHigh extends OperatorBinary {

   public OperatorSetHigh(int precedence) {
      super("hi=", "_sethi_", precedence);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral left, ConstantLiteral right) {
      throw new CompileError("Not implemented");
   }
}
