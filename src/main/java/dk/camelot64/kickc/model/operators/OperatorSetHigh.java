package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.types.SymbolTypeSimple;
import dk.camelot64.kickc.model.values.ConstantLiteral;

/** Binary SetHighByte Operator ( w hi= b ) */
public class OperatorSetHigh extends OperatorBinary {

   public OperatorSetHigh(int precedence) {
      super("hi=", "_sethi_", precedence);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral left, ConstantLiteral right) {
      throw new CompileError("Calculation not implemented " + left + " " + getOperator() + " " + right);
   }

   @Override
   public SymbolType inferType(SymbolTypeSimple left, SymbolTypeSimple right) {
      if(left instanceof SymbolTypePointer) {
         return left;
      } else if(SymbolType.isByte(left)) {
         return SymbolType.WORD;
      } else if(SymbolType.isSByte(left)) {
         return SymbolType.WORD;
      } else if(SymbolType.isWord(left)) {
         return SymbolType.WORD;
      } else if(SymbolType.isSWord(left)) {
         return SymbolType.SWORD;
      } else if(SymbolType.isDWord(left)) {
         return SymbolType.DWORD;
      } else if(SymbolType.isSDWord(left)) {
         return SymbolType.SDWORD;
      }
      throw new RuntimeException("Type inference case not handled " + left + " " + getOperator() + " " + right);
   }

}
