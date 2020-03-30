package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.types.*;
import dk.camelot64.kickc.model.values.ConstantEnumerable;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;
import dk.camelot64.kickc.model.values.ConstantPointer;

/** Binary bitwise exclusive or Operator ( x ^ y ) */
public class OperatorBitwiseXor extends OperatorBinary {

   public OperatorBitwiseXor(int precedence) {
      super("^", "_bxor_", precedence);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral left, ConstantLiteral right) {
      if(left instanceof ConstantPointer && right instanceof ConstantEnumerable) {
         return new ConstantPointer(((ConstantPointer) left).getLocation() ^ ((ConstantEnumerable) right).getInteger(), ((ConstantPointer) left).getElementType());
      } else if(left instanceof ConstantEnumerable && right instanceof ConstantEnumerable) {
         return new ConstantInteger(((ConstantEnumerable) left).getInteger() ^ ((ConstantEnumerable) right).getInteger());
      }
      throw new CompileError("Calculation not implemented " + left + " " + getOperator() + " " + right);
   }

   @Override
   public SymbolType inferType(SymbolType type1, SymbolType type2) {
      // Handle pointers as words
      if(type1 instanceof SymbolTypePointer) {
         type1 = SymbolType.WORD;
      }
      if(type2 instanceof SymbolTypePointer) {
         type2 = SymbolType.WORD;
      }
      // Handle numeric types
      if(SymbolType.isInteger(type1) && SymbolType.isInteger(type2)) {
         return SymbolTypeConversion.convertedMathType((SymbolTypeInteger) type1, (SymbolTypeInteger) type2);
      }
      throw new CompileError("Type inference case not handled " + type1 + " " + getOperator() + " " + type2);
   }


}
