package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.ConstantNotLiteral;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;
import dk.camelot64.kickc.model.values.ConstantPointer;
import dk.camelot64.kickc.model.values.ConstantString;

/** Unary get byte 0 operator byte0(x) */
public class OperatorGetByte0 extends OperatorUnary {

   public OperatorGetByte0(int precedence) {
      super("byte0 ", "_byte0_", precedence);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral operand, ProgramScope scope) {
      if(operand instanceof ConstantInteger) {
         ConstantInteger operandInt = (ConstantInteger) operand;
         return new ConstantInteger(operandInt.getInteger() & 0xff, SymbolType.BYTE);
      } else if(operand instanceof ConstantPointer) {
         return new ConstantInteger(((ConstantPointer) operand).getLocation() & 0xff, SymbolType.BYTE);
      } else if(operand instanceof ConstantString) {
         throw ConstantNotLiteral.getException();
      }
      throw ConstantNotLiteral.getException();
   }

   @Override
   public SymbolType inferType(SymbolType operandType) {
      return SymbolType.BYTE;
   }


}
