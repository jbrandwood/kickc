package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeSimple;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;
import dk.camelot64.kickc.model.values.ConstantPointer;

/** Unary Cast to word operator ( (word) x ) */
public class OperatorCastWord extends OperatorCast {

   public OperatorCastWord(int precedence) {
      super("((word))", "_word_", precedence, SymbolType.WORD);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral value, ProgramScope scope) {
      if(value instanceof ConstantInteger) {
         return new ConstantInteger(0xffff & ((ConstantInteger) value).getValue(), SymbolType.WORD);
      }
      if(value instanceof ConstantPointer) {
         return new ConstantInteger(0xffff & ((ConstantPointer) value).getLocation(), SymbolType.WORD);
      }
      throw new CompileError("Calculation not implemented " + getOperator() + " " + value );
   }

   @Override
   public SymbolType inferType(SymbolTypeSimple operandType) {
      return SymbolType.WORD;
   }
}
