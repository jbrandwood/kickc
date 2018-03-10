package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.values.ConstantLiteral;

/** Unary Pointer Dereference Operator (*p) */
public class OperatorDeref extends OperatorUnary {

   public OperatorDeref(int precedence) {
      super("*", "_deref_", precedence);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral operand) {
      throw new CompileError("Not implemented");
   }

}
