package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeInteger;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.types.SymbolTypeSimple;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;

/** Binary boolean and Operator ( x & y ) */
public class OperatorBoolAnd extends OperatorBinary {

   public OperatorBoolAnd(int precedence) {
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
      // Find smallest bitwise type
      if(type1 instanceof SymbolTypeInteger && type2 instanceof SymbolTypeInteger) {

         for(SymbolTypeInteger candidate : SymbolType.getIntegerTypes()) {
            boolean match1 = ((SymbolTypeInteger) type1).getBits() <= candidate.getBits();
            boolean match2 = ((SymbolTypeInteger) type2).getBits() <= candidate.getBits();
            if(!candidate.isSigned() && (match1 || match2)) {
               return candidate;
            }
         }
      }

      throw new CompileError("Type inference case not handled " + type1 + " " + getOperator() + " " + type2);
   }
}
