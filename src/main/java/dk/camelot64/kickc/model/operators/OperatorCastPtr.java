package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.types.SymbolTypeSimple;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;
import dk.camelot64.kickc.model.values.ConstantPointer;

/** Unary Cast to a pointer ( type* ) */
public class OperatorCastPtr extends OperatorUnary {

   private final SymbolType elementType;

   public OperatorCastPtr(int precedence, SymbolType elementType) {
      super("((" + elementType.toString() + "*))", "_ptr_", precedence);
      this.elementType = elementType;
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral value) {
      if(value instanceof ConstantInteger) {
         return new ConstantPointer(((ConstantInteger) value).getInteger(), elementType);
      }
      throw new CompileError("Calculation not implemented " + getOperator() + " " + value);
   }

   @Override
   public SymbolType inferType(SymbolTypeSimple operandType) {
      return new SymbolTypePointer(elementType);
   }

   public SymbolType getElementType() {
      return elementType;
   }
}
