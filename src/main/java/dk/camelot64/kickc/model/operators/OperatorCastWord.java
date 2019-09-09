package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ConstantNotLiteral;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;
import dk.camelot64.kickc.model.values.ConstantPointer;
import dk.camelot64.kickc.model.values.ConstantString;

/** Unary Cast to word operator ( (word) x ) */
public class OperatorCastWord extends OperatorCast {

   public OperatorCastWord(int precedence) {
      super("((word))", "_word_", precedence, SymbolType.WORD);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral value, ProgramScope scope) {
      if(value instanceof ConstantInteger) {
         return new ConstantInteger(0xffff & ((ConstantInteger) value).getValue(), SymbolType.WORD);
      } else if(value instanceof ConstantPointer) {
         return new ConstantInteger(0xffff & ((ConstantPointer) value).getLocation(), SymbolType.WORD);
      } else if(value instanceof ConstantString) {
         throw new ConstantNotLiteral("String cannot be cast to word");
      }
      throw new CompileError("Calculation not implemented " + getOperator() + " " + value );
   }

   @Override
   public SymbolType inferType(SymbolType operandType) {
      return SymbolType.WORD;
   }
}
