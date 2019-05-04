package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeSimple;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;
import dk.camelot64.kickc.model.values.ConstantPointer;

/** Unary Cast to byte operator ( (byte) x ) */
public class OperatorCastByte extends OperatorUnary {

   public OperatorCastByte(int precedence) {
      super("((byte))", "_byte_", precedence);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral value, ProgramScope scope) {
      if(value instanceof ConstantInteger) {
         return new ConstantInteger(0xff & ((ConstantInteger) value).getValue(), SymbolType.BYTE);
      } else if(value instanceof ConstantPointer) {
         return new ConstantInteger(0xff & ((ConstantPointer) value).getLocation(), SymbolType.BYTE);
      }
      throw new CompileError("Calculation not implemented " + getOperator() + " " + value );
   }

   @Override
   public SymbolType inferType(SymbolTypeSimple operandType) {
      return SymbolType.BYTE;
   }
}
