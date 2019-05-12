package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.types.NoMatchingType;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.types.SymbolTypeSimple;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;

/** Binary DWord Constructor operator (w dw= w) */
public class OperatorDWord extends OperatorBinary {

   public OperatorDWord(int precedence) {
      super("dw=", "_dword_", precedence);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral left, ConstantLiteral right) {
      if(left instanceof ConstantInteger && right instanceof ConstantInteger) {
         return new ConstantInteger(0x10000 * ((ConstantInteger) left).getInteger()  + ((ConstantInteger) right).getInteger());
      }
      throw new CompileError("Calculation not implemented " + left + " " + getOperator() + " " + right);
   }

   @Override
   public SymbolType inferType(SymbolTypeSimple left, SymbolTypeSimple right) {
      // Handle pointers as words
      if(left instanceof SymbolTypePointer) {
         left = SymbolType.WORD;
      }
      if(right instanceof SymbolTypePointer) {
         right = SymbolType.WORD;
      }
      if(SymbolType.BYTE.equals(left)) {
         left = SymbolType.WORD;
      }
      if(SymbolType.BYTE.equals(right)) {
         right = SymbolType.WORD;
      }
      if(SymbolType.WORD.equals(left) && SymbolType.WORD.equals(right)) {
         return SymbolType.DWORD;
      }
      throw new NoMatchingType("DWord constructor cannot use " + left + " " + getOperator() + " " + right);
   }
}
