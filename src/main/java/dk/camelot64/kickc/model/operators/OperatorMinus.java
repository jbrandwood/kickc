package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.InternalError;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeConversion;
import dk.camelot64.kickc.model.types.SymbolTypeInteger;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.values.ConstantChar;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;
import dk.camelot64.kickc.model.values.ConstantPointer;

/** Binary minus Operator ( x - y ) */
public class OperatorMinus extends OperatorBinary {

   public OperatorMinus(int precedence) {
      super("-", "_minus_", precedence);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral left, ConstantLiteral right) {
      if(left instanceof ConstantInteger && right instanceof ConstantInteger) {
         long val = ((ConstantInteger) left).getInteger() - ((ConstantInteger) right).getInteger();
         return new ConstantInteger(val);
      } else if(left instanceof ConstantPointer && right instanceof ConstantInteger) {
         long location = ((ConstantPointer) left).getLocation() - ((ConstantInteger) right).getInteger();
         return new ConstantPointer(location, ((ConstantPointer) left).getElementType());
      } else if(left instanceof ConstantChar && right instanceof ConstantInteger) {
         return new ConstantInteger(((ConstantChar) left).getChar() - ((ConstantInteger) right).getInteger());
      } else if(left instanceof ConstantPointer && right instanceof ConstantPointer) {
         return new ConstantInteger(((ConstantPointer) left).getLocation()-((ConstantPointer) right).getLocation());
      }
      throw new InternalError("Calculation not implemented " + left + " " + getOperator() + " " + right);
   }

   @Override
   public SymbolType inferType(SymbolType type1, SymbolType type2) {
      // Handle pointer types
      if(type1 instanceof SymbolTypePointer && SymbolType.isInteger(type2)) {
         return new SymbolTypePointer(((SymbolTypePointer) type1).getElementType());
      } else if(type1 instanceof SymbolTypePointer && type2 instanceof SymbolTypePointer) {
         return SymbolType.WORD;
      } else if(SymbolType.STRING.equals(type1) && SymbolType.isInteger(type2)) {
         return new SymbolTypePointer(SymbolType.BYTE);
      }
      // Handle numeric types through proper promotion
      if(SymbolType.isInteger(type1) && SymbolType.isInteger(type2)) {
         return SymbolTypeConversion.convertedMathType((SymbolTypeInteger) type1, (SymbolTypeInteger) type2);
      }
      throw new InternalError("Type inference case not handled " + type1 + " " + getOperator() + " " + type2);
   }

}
