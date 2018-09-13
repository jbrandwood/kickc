package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeSimple;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;

/** Unary bitwise Not operator (~b) */
public class OperatorBitwiseNot extends OperatorUnary {

   public OperatorBitwiseNot(int precedence) {
      super("~", "_bnot_", precedence);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral left) {
      if(left instanceof ConstantInteger) {
         return new ConstantInteger(Math.abs(~((ConstantInteger) left).getInteger()));
      }
      throw new CompileError("Calculation not implemented " + getOperator() + " " + left );
   }

   @Override
   public SymbolType inferType(SymbolTypeSimple operandType) {
      return operandType;
   }

}
