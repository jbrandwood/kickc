package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeSimple;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;

/** Unary Negative operator (-) */
public class OperatorNeg extends OperatorUnary {

   public OperatorNeg(int precedence) {
      super("-", "_neg_", precedence);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral operand) {
      if(operand instanceof ConstantInteger) {
         return new ConstantInteger(-((ConstantInteger)operand).getInteger());
      }
      throw new CompileError("Calculation not implemented " + getOperator() + " " + operand );
   }

   @Override
   public SymbolType inferType(SymbolTypeSimple operandType) {
      return operandType;
   }
}
