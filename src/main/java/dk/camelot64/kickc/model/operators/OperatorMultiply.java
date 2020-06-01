package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.ConstantNotLiteral;
import dk.camelot64.kickc.model.types.*;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;

/** Binary multiply Operator ( x * y ) */
public class OperatorMultiply extends OperatorBinary {

   public OperatorMultiply(int precedence) {
      super("*", "_mul_", precedence, true);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral left, ConstantLiteral right) {
      if(left instanceof ConstantInteger && right instanceof ConstantInteger) {
         return new ConstantInteger(((ConstantInteger) left).getInteger() * ((ConstantInteger) right).getInteger());
      }
      throw ConstantNotLiteral.EXCEPTION;
   }

   @Override
   public SymbolType inferType(SymbolType left, SymbolType right) {
      if(left instanceof SymbolTypePointer) {
         if(SymbolType.BYTE.equals(right) || SymbolType.WORD.equals(right) || SymbolType.NUMBER.equals(right)) {
            return new SymbolTypePointer(((SymbolTypePointer) left).getElementType());
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
