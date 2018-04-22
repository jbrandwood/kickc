package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ConstantNotLiteral;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.types.SymbolTypeSimple;
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
   public ConstantLiteral calculateLiteral(ConstantLiteral operand) {
      if(operand instanceof ConstantInteger) {
         ConstantInteger operandInt = (ConstantInteger) operand;
         if(SymbolType.isWord(operandInt.getType()) || SymbolType.isSWord(operandInt.getType())) {
            return new ConstantInteger(operandInt.getInteger()>>8);
         } else if(SymbolType.isDWord(operandInt.getType()) || SymbolType.isSDWord(operandInt.getType())) {
            return new ConstantInteger(operandInt.getInteger()>>16);
         }
      } else if(operand instanceof ConstantPointer) {
         return new ConstantInteger(((ConstantPointer) operand).getLocation()>>8);
      } else if(operand instanceof ConstantString) {
         throw new ConstantNotLiteral("address of string is not literal");
      }
      throw new CompileError("Calculation not implemented " + getOperator() + " " + operand );
   }

   @Override
   public SymbolType inferType(SymbolTypeSimple operandType) {
      if(operandType instanceof SymbolTypePointer || SymbolType.isWord(operandType) || SymbolType.isSWord(operandType)) {
         return SymbolType.BYTE;
      } else if(SymbolType.isDWord(operandType) || SymbolType.isSDWord(operandType)) {
         return SymbolType.WORD;
      } else if(SymbolType.STRING.equals(operandType)) {
         return SymbolType.BYTE;
      }
      throw new CompileError("Type inference not implemented "+getOperator()+" "+operandType);
   }

}
