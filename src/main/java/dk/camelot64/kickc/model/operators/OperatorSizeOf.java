package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;

/** SizeOf operator sizeof(expr). Will be resolved into a constant as soon as the expression has been resolved enough. */
public class OperatorSizeOf extends OperatorUnary {

   public OperatorSizeOf(int precedence) {
      super("sizeof ", "_sizeof_", precedence);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral operand, ProgramScope scope) {
      SymbolType type = operand.getType(scope);
      return new ConstantInteger((long) type.getSizeBytes());
   }

   @Override
   public SymbolType inferType(SymbolType operandType) {
      return SymbolType.BYTE;
   }

}
