package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.ConstantNotLiteral;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;
import dk.camelot64.kickc.model.values.ConstantPointer;
import dk.camelot64.kickc.model.values.ConstantString;

/** Unary get word 0 operator word0(x) */
public class OperatorGetWord1 extends OperatorUnary {

   public OperatorGetWord1(int precedence) {
      super("_word1_", "_word1_", precedence);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral operand, ProgramScope scope) {
      if(operand instanceof ConstantInteger) {
         ConstantInteger operandInt = (ConstantInteger) operand;
         return new ConstantInteger((operandInt.getInteger()>>16) & 0xffff, SymbolType.WORD);
      } else if(operand instanceof ConstantPointer) {
         return new ConstantInteger((((ConstantPointer) operand).getLocation()>>16) & 0xffff, SymbolType.WORD);
      } else if(operand instanceof ConstantString) {
         throw ConstantNotLiteral.getException();
      }
      throw ConstantNotLiteral.getException();
   }

   @Override
   public SymbolType inferType(SymbolType operandType) {
      return SymbolType.WORD;
   }


}
