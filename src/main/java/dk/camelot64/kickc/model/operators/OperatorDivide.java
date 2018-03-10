package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
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
      throw new CompileError("Not implemented");
   }
}
