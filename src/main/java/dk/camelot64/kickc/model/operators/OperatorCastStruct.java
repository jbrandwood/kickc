package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeStruct;
import dk.camelot64.kickc.model.values.ConstantLiteral;

/** Unary Cast to a struct */
public class OperatorCastStruct extends OperatorCast {

   private final SymbolTypeStruct structType;

   public OperatorCastStruct(int precedence, SymbolTypeStruct structType) {
      super("((" + structType.getStructTypeName()+ "))", "_struct_", precedence, structType);
      this.structType = structType;
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral value, ProgramScope scope) {
      throw new CompileError("Calculation not implemented " + getOperator() + " " + value);
   }

   @Override
   public SymbolType inferType(SymbolType operandType) {
      return structType;
   }

}
