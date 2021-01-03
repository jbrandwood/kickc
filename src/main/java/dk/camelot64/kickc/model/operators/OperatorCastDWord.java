package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ConstantNotLiteral;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.*;

/** Unary Cast to double word operator ( (dword) x ) */
public class OperatorCastDWord extends OperatorCast {

   public OperatorCastDWord(int precedence) {
      super("((dword))", "_dword_", precedence, SymbolType.DWORD);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral value, ProgramScope scope) {
      if(value instanceof ConstantInteger) {
         return new ConstantInteger(0xffffffffL & ((ConstantInteger) value).getValue(), SymbolType.DWORD);
      } else if(value instanceof ConstantChar) {
         return new ConstantInteger(((ConstantChar) value).getInteger(), SymbolType.DWORD);
      } else if(value instanceof ConstantPointer) {
         return new ConstantInteger(0xffff & ((ConstantPointer) value).getLocation(), SymbolType.DWORD);
      } else if(value instanceof ConstantString) {
         throw ConstantNotLiteral.getException();
      }
      throw new CompileError("Calculation not implemented " + getOperator() + " " + value );
   }


   @Override
   public SymbolType inferType(SymbolType operandType) {
      return SymbolType.DWORD;
   }
}
