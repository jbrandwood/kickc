package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeInteger;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.types.SymbolTypeSimple;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;

/** Binary bitwise exclusive or Operator ( x ^ y ) */
public class OperatorBitwiseXor extends OperatorBinary {

   public OperatorBitwiseXor(int precedence) {
      super("^", "_bxor_", precedence);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral left, ConstantLiteral right) {
      if(left instanceof ConstantInteger && right instanceof ConstantInteger) {
         return new ConstantInteger(((ConstantInteger) left).getInteger() ^ ((ConstantInteger) right).getInteger());
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
      // Handle numeric types through proper promotion
      if(SymbolType.isInteger(type1) && SymbolType.isInteger(type2)) {
         return SymbolType.promotedBitwiseType((SymbolTypeInteger) type1, (SymbolTypeInteger) type2);
      }
      throw new CompileError("Type inference case not handled " + type1 + " " + getOperator() + " " + type2);
   }


}
