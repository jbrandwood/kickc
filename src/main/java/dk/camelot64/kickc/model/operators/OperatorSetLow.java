package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
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
   public SymbolType inferType(SymbolType left, SymbolType right) {
      if(left instanceof SymbolTypePointer) {
         return new SymbolTypePointer(((SymbolTypePointer) left).getElementType());
      }
      if(SymbolType.WORD.equals(left)) {
         return SymbolType.WORD;
      } else if(SymbolType.SWORD.equals(left)) {
         return SymbolType.SWORD;
      } else if(SymbolType.DWORD.equals(left)) {
         return SymbolType.DWORD;
      } else if(SymbolType.SDWORD.equals(left)) {
         return SymbolType.SDWORD;
      }
      throw new RuntimeException("Type inference case not handled " + left + " " + getOperator() + " " + right);
   }


}
