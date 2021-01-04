package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ConstantNotLiteral;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeConversion;
import dk.camelot64.kickc.model.types.SymbolTypeInteger;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.values.*;

/** Binary plus Operator ( x + y ) */
public class OperatorPlus extends OperatorBinary {

   public OperatorPlus(int precedence) {
      super("+", "_plus_", precedence, true);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral left, ConstantLiteral right) {
      if(left instanceof ConstantPointer && right instanceof ConstantEnumerable) {
         long location = ((ConstantPointer) left).getLocation() + ((ConstantEnumerable) right).getInteger();
         return new ConstantPointer(location, ((ConstantPointer) left).getElementType());
      } else if(left instanceof ConstantEnumerable && right instanceof ConstantEnumerable) {
         return new ConstantInteger(((ConstantEnumerable) left).getInteger() + ((ConstantEnumerable) right).getInteger());
      } else if(left instanceof ConstantString && right instanceof ConstantInteger) {
         throw ConstantNotLiteral.getException();
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
      }
      // Handle numeric types through proper promotion
      if(SymbolType.isInteger(type1) && SymbolType.isInteger(type2)) {
         return SymbolTypeConversion.convertedMathType((SymbolTypeInteger) type1, (SymbolTypeInteger) type2);
      }

      throw new CompileError("Type inference case not handled " + type1 + " " + getOperator() + " " + type2);
   }


}
