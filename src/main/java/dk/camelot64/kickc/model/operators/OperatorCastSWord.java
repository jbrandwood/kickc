package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeSimple;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;

/** Unary Cast to signed word operator ( (signed word) x ) */
public class OperatorCastSWord extends OperatorCast {

   public OperatorCastSWord(int precedence) {
      super("((signed word))", "_sword_", precedence, SymbolType.SWORD);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral value, ProgramScope scope) {
      if(value instanceof ConstantInteger) {
         return new ConstantInteger(0xffff & ((ConstantInteger) value).getValue(), SymbolType.SWORD);
      }
      throw new CompileError("Calculation not implemented " + getOperator() + " " + value );
   }

   @Override
   public SymbolType inferType(SymbolTypeSimple operandType) {
      return SymbolType.SWORD;
   }
}
