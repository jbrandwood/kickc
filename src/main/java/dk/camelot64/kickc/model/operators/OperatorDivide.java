package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.types.*;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;
import dk.camelot64.kickc.model.values.ConstantPointer;

/** Binary division Operator ( x / y ) */
public class OperatorDivide extends OperatorBinary {

   public OperatorDivide(int precedence) {
      super("/", "_div_", precedence);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral left, ConstantLiteral right) {
      if(left instanceof ConstantInteger && right instanceof ConstantInteger) {
         return new ConstantInteger(((ConstantInteger) left).getInteger() / ((ConstantInteger) right).getInteger());
      } else if(left instanceof ConstantPointer && right instanceof ConstantInteger) {
         return new ConstantPointer(
               ((ConstantPointer) left).getLocation() / ((ConstantInteger) right).getInteger(),
               ((ConstantPointer) left).getElementType()
         );
      }
      throw new CompileError("Calculation not implemented " + left + " " + getOperator() + " " + right);
   }

   @Override
   public SymbolType inferType(SymbolTypeSimple left, SymbolTypeSimple right) {
      if(left instanceof SymbolTypePointer) {
         if(SymbolType.isByte(right) || SymbolType.isWord(right)) {
            return left;
         } else {
            throw new NoMatchingType("Cannot divide pointer by "+right.toString());

         }
      }
      // Handle numeric types through proper promotion
      if(SymbolType.isInteger(left) && SymbolType.isInteger(right)) {
         return SymbolType.promotedMathType((SymbolTypeInteger) left, (SymbolTypeInteger) right);
      }

      throw new RuntimeException("Type inference case not handled " + left + " " + getOperator() + " " + right);
   }

}
