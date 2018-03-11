package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.types.SymbolTypeSimple;
import dk.camelot64.kickc.model.values.ConstantLiteral;

/** Binary SetLowByte Operator ( w lo= b ) */
public class OperatorSetLow extends OperatorBinary {

   public OperatorSetLow(int precedence) {
      super("lo=", "_setlo_", precedence);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral left, ConstantLiteral right) {
      throw new CompileError("Calculation not implemented " + left + " " + getOperator() + " " + right);
   }

   @Override
   public SymbolType inferType(SymbolTypeSimple left, SymbolTypeSimple right) {
      if(left instanceof SymbolTypePointer) {
         return left;
      }
      if(SymbolType.isWord(left)) {
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
