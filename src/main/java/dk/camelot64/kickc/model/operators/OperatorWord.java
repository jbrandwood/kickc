package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;

/** Binary Word Constructor operator (b w= b) */
public class OperatorWord extends OperatorBinary {

   public OperatorWord(int precedence) {
      super("w=", "_word_", precedence);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral left, ConstantLiteral right) {
      if(left instanceof ConstantInteger && right instanceof ConstantInteger) {
         return new ConstantInteger(0x100 * ((ConstantInteger) left).getInteger()  + ((ConstantInteger) right).getInteger());
      }
      throw new CompileError("Not implemented");
   }

}
