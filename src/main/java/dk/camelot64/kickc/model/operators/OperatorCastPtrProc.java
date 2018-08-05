package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.types.SymbolTypeProcedure;
import dk.camelot64.kickc.model.types.SymbolTypeSimple;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;
import dk.camelot64.kickc.model.values.ConstantPointer;

/** Unary Cast to procedure pointer operator ( (void()*) x ) */
public class OperatorCastPtrProc extends OperatorUnary {

   public OperatorCastPtrProc(int precedence) {
      super("((void()*))", "_ptrproc_", precedence);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral value) {
      if(value instanceof ConstantInteger) {
         return new ConstantPointer(((ConstantInteger) value).getInteger(), new SymbolTypeProcedure(SymbolType.VOID));
      }
      throw new CompileError("Calculation not implemented " + getOperator() + " " + value);
   }

   @Override
   public SymbolType inferType(SymbolTypeSimple operandType) {
      return new SymbolTypePointer(new SymbolTypeProcedure(SymbolType.VOID));
   }

}
