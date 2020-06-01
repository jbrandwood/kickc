package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ConstantNotLiteral;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.*;

/** Unary Cast to word operator ( (word) x ) */
public class OperatorCastWord extends OperatorCast {

   public OperatorCastWord(int precedence) {
      super("((word))", "_word_", precedence, SymbolType.WORD);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral value, ProgramScope scope) {
      if(value instanceof ConstantInteger) {
         return new ConstantInteger(0xffff & ((ConstantInteger) value).getValue(), SymbolType.WORD);
      } else if(value instanceof ConstantChar) {
         return new ConstantInteger(((ConstantChar) value).getInteger(), SymbolType.WORD);
      } else if(value instanceof ConstantPointer) {
         return new ConstantInteger(0xffff & ((ConstantPointer) value).getLocation(), SymbolType.WORD);
      } else if(value instanceof ConstantString) {
         throw ConstantNotLiteral.EXCEPTION;
      }
      throw new CompileError("Calculation not implemented " + getOperator() + " " + value );
   }

   @Override
   public SymbolType inferType(SymbolType operandType) {
      return SymbolType.WORD;
   }
}
