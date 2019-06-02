package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.ConstantBool;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;
import dk.camelot64.kickc.model.values.ConstantPointer;

/** Unary Cast to boolean operator ( (boolean) x ) */
public class OperatorCastBool extends OperatorCast  {

   public OperatorCastBool(int precedence) {
      super("((bool))", "_bool_", precedence, SymbolType.BOOLEAN);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral value, ProgramScope scope) {
      if(value instanceof ConstantInteger) {
         return new ConstantBool(((ConstantInteger) value).getInteger()!=0L);
      } else if(value instanceof ConstantPointer) {
         return new ConstantBool(((ConstantPointer) value).getLocation()!=0L);
      }
      throw new CompileError("Calculation not implemented " + getOperator() + " " + value );
   }

   @Override
   public SymbolType inferType(SymbolType operandType) {
      return SymbolType.BOOLEAN;
   }
}
