package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.values.ConstantLiteral;

/** Binary SetLowByte Operator ( w lo= b ) */
public class OperatorSetLow extends OperatorBinary {

   public OperatorSetLow(int precedence) {
      super("lo=", "_setlo_", precedence);
   }

   @Override
   public ConstantLiteral calculate(ConstantLiteral left, ConstantLiteral right) {
      throw new CompileError("Not implemented");
   }

}
