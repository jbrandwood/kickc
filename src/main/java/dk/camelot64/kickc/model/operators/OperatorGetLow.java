package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ConstantNotLiteral;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.types.SymbolTypeSimple;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;
import dk.camelot64.kickc.model.values.ConstantPointer;
import dk.camelot64.kickc.model.values.ConstantString;

/** Unary get low operator (<b) */
public class OperatorGetLow extends OperatorUnary {

   public OperatorGetLow(int precedence) {
      super("<", "_lo_", precedence);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral operand, ProgramScope scope) {
      if(operand instanceof ConstantInteger) {
         ConstantInteger operandInt = (ConstantInteger) operand;
         if(SymbolType.WORD.equals(operandInt.getType()) || SymbolType.SWORD.equals(operandInt.getType())) {
            return new ConstantInteger(operandInt.getInteger()&0xff);
         } else if(SymbolType.DWORD.equals(operandInt.getType()) || SymbolType.SDWORD.equals(operandInt.getType())) {
            return new ConstantInteger(operandInt.getInteger()&0xffff);
         }
      } else if(operand instanceof ConstantPointer) {
         return new ConstantInteger(((ConstantPointer) operand).getLocation()&0xff);
      } else if(operand instanceof ConstantString) {
         throw new ConstantNotLiteral("address of string is not literal");
      }
      throw new CompileError("Calculation not implemented " + getOperator() + " " + operand );
   }

   @Override
   public SymbolType inferType(SymbolTypeSimple operandType) {
      if(operandType instanceof SymbolTypePointer || SymbolType.WORD.equals(operandType) || SymbolType.SWORD.equals(operandType)) {
         return SymbolType.BYTE;
      } else if(SymbolType.DWORD.equals(operandType) || SymbolType.SDWORD.equals(operandType)) {
         return SymbolType.WORD;
      } else if(SymbolType.STRING.equals(operandType)) {
         return SymbolType.BYTE;
      } else if(SymbolType.NUMBER.equals(operandType)) {
         return SymbolType.NUMBER;
      }
      throw new CompileError("Type inference not implemented "+getOperator()+" "+operandType);
   }


}
