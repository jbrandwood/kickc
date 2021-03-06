package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.*;

/** Unary Cast to byte operator ( (byte) x ) */
public class OperatorCastByte extends OperatorCast {

   public OperatorCastByte(int precedence) {
      super("((byte))", "_byte_", precedence, SymbolType.BYTE);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral value, ProgramScope scope) {
      if(value instanceof ConstantInteger) {
         return new ConstantInteger(0xff & ((ConstantInteger) value).getValue(), SymbolType.BYTE);
      } else if(value instanceof ConstantPointer) {
         return new ConstantInteger(0xff & ((ConstantPointer) value).getLocation(), SymbolType.BYTE);
      } else if(value instanceof ConstantChar) {
         return new ConstantInteger(((ConstantChar) value).getInteger(), SymbolType.BYTE);
      } else if(value instanceof ConstantBool) {
         return new ConstantInteger(((ConstantBool) value).getBool() ? 0xffL : 0x00L, SymbolType.BYTE);
      } else
         throw new CompileError("Calculation not implemented " + getOperator() + " " + value);
   }

   @Override
   public SymbolType inferType(SymbolType operandType) {
      return SymbolType.BYTE;
   }
}
