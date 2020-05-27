package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.types.*;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;
import dk.camelot64.kickc.model.values.ConstantPointer;

/** Numeric modulo operator ie. remainder after division ( x % y ) */
public class OperatorModulo extends OperatorBinary {

   public OperatorModulo(int precedence) {
      super("%", "_mod_", precedence, false);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral left, ConstantLiteral right) {
      if(left instanceof ConstantInteger && right instanceof ConstantInteger) {
         return new ConstantInteger(((ConstantInteger) left).getInteger() % ((ConstantInteger) right).getInteger());
      } else if(left instanceof ConstantPointer && right instanceof ConstantInteger) {
         return new ConstantInteger(((ConstantPointer) left).getLocation() % ((ConstantInteger) right).getInteger());
      }
      throw new CompileError("Calculation not implemented " + left + " " + getOperator() + " " + right);
   }

   @Override
   public SymbolType inferType(SymbolType left, SymbolType right) {
      // Handle numeric types through proper promotion
      if(SymbolType.isInteger(left) && SymbolType.isInteger(right)) {
         return SymbolTypeConversion.convertedMathType((SymbolTypeInteger) left, (SymbolTypeInteger) right);
      }
      if(left instanceof ConstantPointer && right instanceof ConstantInteger) {
         return ((ConstantInteger) right).getType();
      }
      throw new RuntimeException("Type inference case not handled " + left + " " + getOperator() + " " + right);
   }

}
