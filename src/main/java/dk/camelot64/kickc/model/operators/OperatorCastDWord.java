package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;

/** Unary Cast to double word operator ( (dword) x ) */
public class OperatorCastDWord extends OperatorUnary {

   public OperatorCastDWord(int precedence) {
      super("((dword))", "_dword_", precedence);
   }

   @Override
   public ConstantLiteral calculate(ConstantLiteral value) {
      if(value instanceof ConstantInteger) {
         return new ConstantInteger(0xffffffffL & ((ConstantInteger) value).getValue());
      }
      throw new CompileError("Not implemented");
   }


}
