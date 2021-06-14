package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.ConstantNotLiteral;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;
import dk.camelot64.kickc.model.values.ConstantPointer;
import dk.camelot64.kickc.model.values.ConstantString;

/** Unary get byte 3 operator byte3(x) */
public class OperatorGetByte3 extends OperatorUnary {

   public OperatorGetByte3(int precedence) {
      super("byte3 ", "_byte3_", precedence);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral operand, ProgramScope scope) {
      if(operand instanceof ConstantInteger) {
         ConstantInteger operandInt = (ConstantInteger) operand;
         return new ConstantInteger((operandInt.getInteger()>>24)&0xff, SymbolType.BYTE);
      } else if(operand instanceof ConstantPointer) {
         return new ConstantInteger((((ConstantPointer) operand).getLocation()>>24) & 0xff, SymbolType.BYTE);
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
