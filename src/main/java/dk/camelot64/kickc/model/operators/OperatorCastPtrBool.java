package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.types.SymbolTypeSimple;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;
import dk.camelot64.kickc.model.values.ConstantPointer;

/** Unary Cast to boolean pointer operator ( (boolean*) x ) */
public class OperatorCastPtrBool extends OperatorUnary {

   public OperatorCastPtrBool(int precedence) {
      super("((boolean*))", "_ptrbo_", precedence);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral value) {
      if(value instanceof ConstantInteger) {
         return new ConstantPointer(((ConstantInteger) value).getInteger(), SymbolType.BOOLEAN);
      }
      throw new CompileError("Calculation not implemented " + getOperator() + " " + value );
   }

   @Override
   public SymbolType inferType(SymbolTypeSimple operandType) {
      return new SymbolTypePointer(SymbolType.BOOLEAN);
   }
}
