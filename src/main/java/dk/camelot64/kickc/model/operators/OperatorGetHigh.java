package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;
import dk.camelot64.kickc.model.values.ConstantPointer;

/** Unary get high operator (>b) */
public class OperatorGetHigh extends OperatorUnary {

   public OperatorGetHigh(int precedence) {
      super(">", "_hi_", precedence);
   }

   @Override
   public ConstantLiteral calculate(ConstantLiteral operand) {
      if(operand instanceof ConstantInteger) {
         ConstantInteger operandInt = (ConstantInteger) operand;
         if(SymbolType.isWord(operandInt.getType())) {
            return new ConstantInteger(operandInt.getInteger()>>8);
         } else if(SymbolType.isDWord(operandInt.getType())) {
            return new ConstantInteger(operandInt.getInteger()>>16);
         }
      } else if(operand instanceof ConstantPointer) {
         return new ConstantInteger(((ConstantPointer) operand).getLocation()>>8);
      }
      throw new CompileError("Not implemented");
   }
}
