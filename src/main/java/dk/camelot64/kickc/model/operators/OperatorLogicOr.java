package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.values.ConstantBool;
import dk.camelot64.kickc.model.values.ConstantLiteral;

/** Binary logic or Operator ( x || y ) */
public class OperatorLogicOr extends OperatorBinary {

   public OperatorLogicOr(int precedence) {
      super("||", "_or_", precedence);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral left, ConstantLiteral right) {
      if(left instanceof ConstantBool && right instanceof ConstantBool) {
         return new ConstantBool(((ConstantBool) left).getBool() || ((ConstantBool) right).getBool());
      }
      throw new CompileError("Not implemented");
   }

}
