package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.ConstantBool;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;
import dk.camelot64.kickc.model.values.ConstantPointer;

import java.util.Objects;

/** Binary not-equal Operator ( x != y ) */
public class OperatorNotEqual extends OperatorBinary {

   public OperatorNotEqual(int precedence) {
      super("!=", "_neq_", precedence);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral left, ConstantLiteral right) {
      if(left instanceof ConstantInteger && right instanceof ConstantInteger) {
         return new ConstantBool(!Objects.equals(((ConstantInteger) left).getInteger(), ((ConstantInteger) right).getInteger()));
      } else if(left instanceof ConstantPointer && right instanceof ConstantPointer) {
         return new ConstantBool(!Objects.equals(((ConstantPointer) left).getLocation(), ((ConstantPointer) right).getLocation()));
      }

      throw new CompileError("Calculation not implemented " + left + " " + getOperator() + " " + right);
   }

   @Override
   public SymbolType inferType(SymbolType left, SymbolType right) {
      return SymbolType.BOOLEAN;
   }


}
