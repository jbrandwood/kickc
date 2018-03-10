package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;

/** Unary Cast to signed word operator ( (signed word) x ) */
public class OperatorCastSWord extends OperatorUnary {

   public OperatorCastSWord(int precedence) {
      super("((signed word))", "_sword_", precedence);
   }

   @Override
   public ConstantLiteral calculate(ConstantLiteral value) {
      if(value instanceof ConstantInteger) {
         return new ConstantInteger(0xffff & ((ConstantInteger) value).getValue());
      }
      throw new CompileError("Not implemented");
   }

}
