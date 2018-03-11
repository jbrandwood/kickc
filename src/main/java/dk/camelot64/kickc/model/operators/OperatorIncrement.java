package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeSimple;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;

/** Unary Increment operator (++) */
public class OperatorIncrement extends OperatorUnary {

   public OperatorIncrement(int precedence) {
      super("++", "_inc_", precedence);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral operand) {
      if(operand instanceof ConstantInteger ) {
         return new ConstantInteger(((ConstantInteger) operand).getInteger() + 1);
      }
      throw new CompileError("Calculation not implemented " + getOperator() + " " + operand );
   }

   @Override
   public SymbolType inferType(SymbolTypeSimple operandType) {
      return operandType;
   }
}
