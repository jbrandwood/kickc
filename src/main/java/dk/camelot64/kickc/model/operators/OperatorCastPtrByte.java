package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;
import dk.camelot64.kickc.model.values.ConstantPointer;

/** Unary Cast to byte pointer operator ( (byte*) x ) */
public class OperatorCastPtrByte extends OperatorUnary {

   public OperatorCastPtrByte(int precedence) {
      super("((byte*))", "_ptrby_", precedence);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral value) {
      if(value instanceof ConstantInteger) {
         return new ConstantPointer(((ConstantInteger) value).getInteger(), SymbolType.BYTE);
      }
      throw new CompileError("Not implemented");
   }

}
