package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;
import dk.camelot64.kickc.model.values.ConstantPointer;

/** Unary Cast to word operator ( (word) x ) */
public class OperatorCastWord extends OperatorUnary {

   public OperatorCastWord(int precedence) {
      super("((word))", "_word_", precedence);
   }

   @Override
   public ConstantLiteral calculate(ConstantLiteral value) {
      if(value instanceof ConstantInteger) {
         return new ConstantInteger(0xffff & ((ConstantInteger) value).getValue());
      }
      if(value instanceof ConstantPointer) {
         return new ConstantInteger( (long) (0xffff & ((ConstantPointer) value).getLocation()));
      }
      throw new CompileError("Not implemented");
   }

}
