package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.types.*;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;

/** Binary bitwise and Operator ( x & y ) */
public class OperatorBitwiseAnd extends OperatorBinary {

   public OperatorBitwiseAnd(int precedence) {
      super("&", "_band_", precedence);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral left, ConstantLiteral right) {
      if(left instanceof ConstantInteger && right instanceof ConstantInteger) {
         return new ConstantInteger(((ConstantInteger) left).getInteger() & ((ConstantInteger) right).getInteger());
      }
      throw new CompileError("Calculation not implemented " + left + " " + getOperator() + " " + right);
   }

   @Override
   public SymbolType inferType(SymbolTypeSimple type1, SymbolTypeSimple type2) {
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
