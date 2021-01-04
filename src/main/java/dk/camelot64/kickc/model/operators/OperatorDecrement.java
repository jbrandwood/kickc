package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.ConstantNotLiteral;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;
import dk.camelot64.kickc.model.values.ConstantPointer;

/** Unary Decrement operator (--) */
public class OperatorDecrement extends OperatorUnary {

   public OperatorDecrement(int precedence) {
      super("--", "_dec_", precedence);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral operand, ProgramScope scope) {
      if(operand instanceof ConstantInteger ) {
         return new ConstantInteger(((ConstantInteger) operand).getInteger() -1);
      } else if(operand instanceof ConstantPointer) {
         return new ConstantPointer(0xffff&(((ConstantPointer) operand).getLocation()-1), ((ConstantPointer) operand).getElementType());
      }
      throw ConstantNotLiteral.getException();
   }

   @Override
   public SymbolType inferType(SymbolType operandType) {
      return operandType;
   }
}
