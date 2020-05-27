package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.values.ConstantLiteral;

/** Binary Pointer Dereference with an index Operator ( p[i] / *(p+i) ) */
public class OperatorDerefIdx extends OperatorBinary {

   public OperatorDerefIdx(int precedence) {
      super("*idx=", "_derefidx_", precedence, false);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral left, ConstantLiteral right) {
      throw new CompileError("Calculation not implemented " + left + " " + getOperator() + " " + right);
   }

   @Override
   public SymbolType inferType(SymbolType left, SymbolType right) {
      if(left instanceof SymbolTypePointer) {
         return ((SymbolTypePointer) left).getElementType();
      }
      throw new RuntimeException("Type error: Dereferencing a non-pointer " + left + "[" + right + "]");
   }
}
