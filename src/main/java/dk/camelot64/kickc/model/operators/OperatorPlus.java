package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.*;

/** Binary plus Operator ( x + y ) */
public class OperatorPlus extends OperatorBinary {

   public OperatorPlus(int precedence) {
      super("+", "_plus_", precedence);
   }

   @Override
   public ConstantLiteral calculate(ConstantLiteral left, ConstantLiteral right) {
      if(left instanceof ConstantInteger && right instanceof ConstantInteger) {
         return new ConstantInteger(((ConstantInteger) left).getInteger() + ((ConstantInteger) right).getInteger());
      } else if(left instanceof ConstantInteger && right instanceof ConstantChar) {
         return new ConstantInteger(((ConstantInteger) left).getInteger() + ((ConstantChar) right).getChar());
      } else if(left instanceof ConstantChar && right instanceof ConstantInteger) {
         return new ConstantInteger(((ConstantChar) left).getChar() + ((ConstantInteger) right).getInteger());
      } else if(left instanceof ConstantString && right instanceof ConstantString) {
         return new ConstantString(((ConstantString) left).getString() + ((ConstantString) right).getString());
      } else if(left instanceof ConstantString && right instanceof ConstantChar) {
         return new ConstantString(((ConstantString) left).getString() + ((ConstantChar) right).getChar());
      } else if(left instanceof ConstantString && right instanceof ConstantInteger && SymbolType.isByte(((ConstantInteger)right).getType())) {
         Character character = (char) ((ConstantInteger) right).getInteger().byteValue();
         return new ConstantString(((ConstantString) left).getString() + character);
      } else if(left instanceof ConstantPointer && right instanceof ConstantInteger) {
         long location = ((ConstantPointer) left).getLocation() + ((ConstantInteger) right).getInteger();
         return new ConstantPointer(location, ((ConstantPointer) left).getElementType());
      }

      throw new CompileError("Not implemented");
   }

}
