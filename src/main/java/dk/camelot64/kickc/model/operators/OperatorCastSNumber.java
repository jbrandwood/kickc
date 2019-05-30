package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;

/** Unary Cast to signed number  operator ( (snumber) x ) */
public class OperatorCastSNumber extends OperatorCast {

   public OperatorCastSNumber(int precedence) {
      super("((snumber))", "_snumber_", precedence, SymbolType.SNUMBER);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral value, ProgramScope scope) {
      if(value instanceof ConstantInteger)
         return new ConstantInteger(((ConstantInteger) value).getValue(), SymbolType.SNUMBER);
      throw new CompileError("Calculation not implemented " + getOperator() + " " + value );
   }

   @Override
   public SymbolType inferType(SymbolType operandType) {
      return SymbolType.SNUMBER;
   }
}
