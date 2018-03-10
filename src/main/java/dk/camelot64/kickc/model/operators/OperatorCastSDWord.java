package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;

/** Unary Cast to signed double word operator ( (signed dword) x ) */
public class OperatorCastSDWord extends OperatorUnary {

   public OperatorCastSDWord(int precedence) {
      super("((signed dword))", "_sdword_", precedence);
   }

   @Override
   public ConstantLiteral calculate(ConstantLiteral value) {
      if(value instanceof ConstantInteger) {
         return new ConstantInteger(0xffffffffL & ((ConstantInteger) value).getValue());
      }
      throw new CompileError("Not implemented");
   }

}
