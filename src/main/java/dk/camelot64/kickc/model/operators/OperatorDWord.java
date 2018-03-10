package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;

/** Binary DWord Constructor operator (w dw= w) */
public class OperatorDWord extends OperatorBinary {

   public OperatorDWord(int precedence) {
      super("dw=", "_dword_", precedence);
   }

   @Override
   public ConstantLiteral calculate(ConstantLiteral left, ConstantLiteral right) {
      if(left instanceof ConstantInteger && right instanceof ConstantInteger) {
         return new ConstantInteger(0x10000 * ((ConstantInteger) left).getInteger()  + ((ConstantInteger) right).getInteger());
      }
      throw new CompileError("Not implemented");
   }

}
