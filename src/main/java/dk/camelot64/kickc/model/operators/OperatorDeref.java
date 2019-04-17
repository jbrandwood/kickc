package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.types.SymbolTypeSimple;
import dk.camelot64.kickc.model.values.ConstantLiteral;

/** Unary Pointer Dereference Operator (*p) */
public class OperatorDeref extends OperatorUnary {

   public OperatorDeref(int precedence) {
      super("*", "_deref_", precedence);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral operand, ProgramScope scope) {
      throw new CompileError("Calculation not implemented " + getOperator() + " " + operand );
   }

   @Override
   public SymbolType inferType(SymbolTypeSimple operandType) {
      if(operandType instanceof SymbolTypePointer) {
         return ((SymbolTypePointer) operandType).getElementType();
      }
      throw new CompileError("Type error: Dereferencing a non-pointer " + operandType);
   }

}
