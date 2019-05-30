package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.ConstantNotLiteral;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;

/** Unary Decrement operator (--) */
public class OperatorDecrement extends OperatorUnary {

   public OperatorDecrement(int precedence) {
      super("--", "_dec_", precedence);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral operand, ProgramScope scope) {
      if(operand instanceof ConstantInteger ) {
         return new ConstantInteger(((ConstantInteger) operand).getInteger() -1);
      }
      throw new ConstantNotLiteral("Calculation not literal " + getOperator() + " " + operand );
   }

   @Override
   public SymbolType inferType(SymbolType operandType) {
      return operandType;
   }
}
