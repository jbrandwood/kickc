package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;
import dk.camelot64.kickc.model.values.ConstantPointer;

/** Unary get low operator (<b) */
public class OperatorGetLow extends OperatorUnary {

   public OperatorGetLow(int precedence) {
      super("<", "_lo_", precedence);
   }

   @Override
   public ConstantLiteral calculate(ConstantLiteral operand) {
      if(operand instanceof ConstantInteger) {
         ConstantInteger operandInt = (ConstantInteger) operand;
         if(SymbolType.isWord(operandInt.getType())) {
            return new ConstantInteger(operandInt.getInteger()&0xff);
         } else if(SymbolType.isDWord(operandInt.getType())) {
            return new ConstantInteger(operandInt.getInteger()&0xffff);
         }
      } else if(operand instanceof ConstantPointer) {
         return new ConstantInteger(((ConstantPointer) operand).getLocation()&0xff);
      }
      throw new CompileError("Not implemented");
   }

}
