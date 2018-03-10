package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.values.ConstantBool;
import dk.camelot64.kickc.model.values.ConstantLiteral;

/** Unary Logic Not operator (!b) */
public class OperatorLogicNot extends OperatorUnary {

   public OperatorLogicNot(int precedence) {
      super("!", "_not_", precedence);
   }

   @Override
   public ConstantLiteral calculate(ConstantLiteral left) {
      if(left instanceof ConstantBool) {
         return new ConstantBool(!((ConstantBool) left).getBool() );
      }
      throw new CompileError("Not implemented");
   }


}
