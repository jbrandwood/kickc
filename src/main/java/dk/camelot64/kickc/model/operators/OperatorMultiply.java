package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.types.*;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;

/** Binary multiply Operator ( x * y ) */
public class OperatorMultiply extends OperatorBinary {

   public OperatorMultiply(int precedence) {
      super("*", "_mul_", precedence);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral left, ConstantLiteral right) {
      if(left instanceof ConstantInteger && right instanceof ConstantInteger) {
         return new ConstantInteger(((ConstantInteger) left).getInteger() * ((ConstantInteger) right).getInteger());
      }
      throw new CompileError("Calculation not implemented " + left + " " + getOperator() + " " + right);
   }

   @Override
   public SymbolType inferType(SymbolTypeSimple left, SymbolTypeSimple right) {
      if(left instanceof SymbolTypePointer) {
         if(right.equals(SymbolType.BYTE) || right.equals(SymbolType.WORD)|| right.equals(SymbolType.NUMBER)) {
            return left;
         } else {
            throw new NoMatchingType("Cannot multiply pointer by "+right.toString());
         }
      }
      // Handle numeric types through proper promotion
      if(SymbolType.isInteger(left) && SymbolType.isInteger(right)) {
         return SymbolTypeConversion.convertedMathType((SymbolTypeInteger) left, (SymbolTypeInteger) right);
      }
      throw new RuntimeException("Type inference case not handled " + left + " " + getOperator() + " " + right);
   }
}
