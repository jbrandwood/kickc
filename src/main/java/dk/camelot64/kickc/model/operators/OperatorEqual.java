package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.values.ConstantBool;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;

import java.util.Objects;

/** Binary equal Operator ( x == y ) */
public class OperatorEqual extends OperatorBinary {

   public OperatorEqual(int precedence) {
      super("==", "_eq_", precedence);
   }

   @Override
   public ConstantLiteral calculate(ConstantLiteral left, ConstantLiteral right) {
      if(left instanceof ConstantInteger && right instanceof ConstantInteger) {
         return new ConstantBool(Objects.equals(((ConstantInteger) left).getInteger(), ((ConstantInteger) right).getInteger()));
      }
      throw new CompileError("Not implemented");
   }

}
