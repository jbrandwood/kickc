package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ConstantNotLiteral;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;
import dk.camelot64.kickc.model.values.ConstantPointer;
import dk.camelot64.kickc.model.values.ConstantString;

/** Unary get high operator (>b) */
public class OperatorGetHigh extends OperatorUnary {

   public OperatorGetHigh(int precedence) {
      super(">", "_hi_", precedence);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral operand, ProgramScope scope) {
      if(operand instanceof ConstantInteger) {
         ConstantInteger operandInt = (ConstantInteger) operand;
         if(SymbolType.WORD.equals(operandInt.getType()) || SymbolType.SWORD.equals(operandInt.getType())) {
            return new ConstantInteger(operandInt.getInteger()>>8);
         } else if(SymbolType.DWORD.equals(operandInt.getType()) || SymbolType.SDWORD.equals(operandInt.getType())) {
            return new ConstantInteger(operandInt.getInteger()>>16);
         } else if(SymbolType.BYTE.equals(operandInt.getType()) || SymbolType.SBYTE.equals(operandInt.getType())) {
            return new ConstantInteger(0L, SymbolType.BYTE);
         } else if(SymbolType.NUMBER.equals(operandInt.getType())) {
            throw new ConstantNotLiteral("Operand not resolved "+operand);
         }
      } else if(operand instanceof ConstantPointer) {
         return new ConstantInteger(((ConstantPointer) operand).getLocation()>>8);
      } else if(operand instanceof ConstantString) {
         throw new ConstantNotLiteral("address of string is not literal");
      }
      throw new CompileError("Calculation not implemented " + getOperator() + " " + operand );
   }

   @Override
   public SymbolType inferType(SymbolType operandType) {
      if(operandType instanceof SymbolTypePointer || SymbolType.WORD.equals(operandType) || SymbolType.SWORD.equals(operandType)) {
         return SymbolType.BYTE;
      } else if(SymbolType.DWORD.equals(operandType) || SymbolType.SDWORD.equals(operandType)) {
         return SymbolType.WORD;
      } else if(SymbolType.BYTE.equals(operandType) || SymbolType.SBYTE.equals(operandType)) {
         return SymbolType.BYTE;
      } else if(SymbolType.STRING.equals(operandType)) {
         return SymbolType.BYTE;
      } else if(SymbolType.NUMBER.equals(operandType)) {
         return SymbolType.NUMBER;
      }
      throw new CompileError("Type inference not implemented "+getOperator()+" "+operandType);
   }

}
