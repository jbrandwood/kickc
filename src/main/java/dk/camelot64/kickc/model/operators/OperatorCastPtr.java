package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;
import dk.camelot64.kickc.model.values.ConstantPointer;

/** Unary Cast to a pointer ( type* ) */
public class OperatorCastPtr extends OperatorCast {

   private final SymbolType elementType;

   public OperatorCastPtr(int precedence, SymbolType elementType) {
      super("((" + elementType.toString() + "*))", "_ptr_", precedence, new SymbolTypePointer(elementType));
      this.elementType = elementType;
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral value, ProgramScope scope) {
      if(value instanceof ConstantInteger) {
         return new ConstantPointer(((ConstantInteger) value).getInteger(), elementType);
      } else if(value instanceof ConstantPointer) {
         return new ConstantPointer(((ConstantPointer) value).getLocation(), elementType);
      }
      if(value instanceof ConstantPointer) {
         return new ConstantPointer(((ConstantPointer) value).getLocation(), elementType);
      }
      throw new CompileError("Calculation not implemented " + getOperator() + " " + value);
   }

   @Override
   public SymbolType inferType(SymbolType operandType) {
      return new SymbolTypePointer(elementType);
   }

   public SymbolType getElementType() {
      return elementType;
   }
}
