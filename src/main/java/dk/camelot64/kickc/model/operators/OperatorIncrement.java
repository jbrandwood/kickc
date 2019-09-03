package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.ConstantNotLiteral;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;
import dk.camelot64.kickc.model.values.ConstantPointer;

/** Unary Increment operator (++) */
public class OperatorIncrement extends OperatorUnary {

   public OperatorIncrement(int precedence) {
      super("++", "_inc_", precedence);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral operand, ProgramScope scope) {
      if(operand instanceof ConstantInteger ) {
         return new ConstantInteger(((ConstantInteger) operand).getInteger() + 1);
      } else if(operand instanceof ConstantPointer) {
         return new ConstantPointer(0xffff&(((ConstantPointer) operand).getLocation()+1), ((ConstantPointer) operand).getElementType());
      }
      throw new ConstantNotLiteral("Calculation not literal " + getOperator() + " " + operand );
   }

   @Override
   public SymbolType inferType(SymbolType operandType) {
      return operandType;
   }
}
