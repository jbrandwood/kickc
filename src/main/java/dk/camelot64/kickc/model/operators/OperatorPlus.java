package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ConstantNotLiteral;
import dk.camelot64.kickc.model.types.*;
import dk.camelot64.kickc.model.values.*;

/** Binary plus Operator ( x + y ) */
public class OperatorPlus extends OperatorBinary {

   public OperatorPlus(int precedence) {
      super("+", "_plus_", precedence);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral left, ConstantLiteral right) {
      if(left instanceof ConstantInteger && right instanceof ConstantInteger) {
         return new ConstantInteger(((ConstantInteger) left).getInteger() + ((ConstantInteger) right).getInteger());
      } else if(left instanceof ConstantInteger && right instanceof ConstantChar) {
         return new ConstantInteger(((ConstantInteger) left).getInteger() + ((ConstantChar) right).getChar());
      } else if(left instanceof ConstantChar && right instanceof ConstantInteger) {
         return new ConstantInteger(((ConstantChar) left).getChar() + ((ConstantInteger) right).getInteger());
      } else if(left instanceof ConstantPointer && right instanceof ConstantInteger) {
         long location = ((ConstantPointer) left).getLocation() + ((ConstantInteger) right).getInteger();
         return new ConstantPointer(location, ((ConstantPointer) left).getElementType());
      } else if(left instanceof ConstantInteger && right instanceof ConstantPointer) {
         long location = ((ConstantPointer) right).getLocation() + ((ConstantInteger) left).getInteger();
         return new ConstantPointer(location, ((ConstantPointer) right).getElementType());
      } else if(left instanceof ConstantString && right instanceof ConstantInteger) {
         throw new ConstantNotLiteral("String pointer not literal");
      }
      throw new CompileError("Calculation not implemented " + left + " " + getOperator() + " " + right);
   }

   @Override
   public SymbolType inferType(SymbolType type1, SymbolType type2) {
      // Handle all non-numeric types
      if(SymbolType.isInteger(type1) && type2 instanceof SymbolTypePointer) {
         return new SymbolTypePointer(((SymbolTypePointer) type2).getElementType());
      } else if(type1 instanceof SymbolTypePointer && SymbolType.isInteger(type2)) {
         return new SymbolTypePointer(((SymbolTypePointer) type1).getElementType());
      } else if(SymbolType.STRING.equals(type1) && SymbolType.isInteger(type2)) {
         return new SymbolTypePointer(SymbolType.BYTE);
      }
      // Handle numeric types through proper promotion
      if(SymbolType.isInteger(type1) && SymbolType.isInteger(type2)) {
         return SymbolTypeConversion.convertedMathType( (SymbolTypeInteger) type1, (SymbolTypeInteger)type2);
      }

      throw new CompileError("Type inference case not handled " + type1 + " " + getOperator() + " " + type2);
   }


}
