package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.values.ConstantLiteral;

/** Binary Pointer Dereference with an index Operator ( p[i] / *(p+i) ) */
public class OperatorDerefIdx extends OperatorBinary {

   public OperatorDerefIdx(int precedence) {
      super("*idx=", "_derefidx_", precedence);
   }

   @Override
   public ConstantLiteral calculate(ConstantLiteral left, ConstantLiteral right) {
      throw new CompileError("Not implemented");
   }
}
