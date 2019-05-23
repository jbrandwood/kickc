package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;
import dk.camelot64.kickc.model.values.ConstantPointer;

/** Unary Cast to unsigned number  operator ( (unumber) x ) */
public class OperatorCastUNumber extends OperatorCast {

   public OperatorCastUNumber(int precedence) {
      super("((unumber))", "_unumber_", precedence, SymbolType.UNUMBER);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral value, ProgramScope scope) {
      if(value instanceof ConstantInteger)
         return new ConstantInteger(((ConstantInteger) value).getValue(), SymbolType.UNUMBER);
      throw new CompileError("Calculation not implemented " + getOperator() + " " + value );
   }

   @Override
   public SymbolType inferType(SymbolType operandType) {
      return SymbolType.UNUMBER;
   }
}
