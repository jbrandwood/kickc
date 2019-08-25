package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.ConstantNotLiteral;
import dk.camelot64.kickc.model.InternalError;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;
import dk.camelot64.kickc.model.values.ConstantPointer;
import dk.camelot64.kickc.model.values.ConstantString;

/** Unary Cast to a pointer ( type* ) */
public class OperatorCastPtr extends OperatorCast {

   private final SymbolTypePointer pointerType;

   public OperatorCastPtr(int precedence, SymbolTypePointer pointerType) {
      super("((" + pointerType.toString() + "))", "_ptr_", precedence, pointerType);
      this.pointerType = pointerType;
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral value, ProgramScope scope) {
      if(value instanceof ConstantInteger) {
         return new ConstantPointer(((ConstantInteger) value).getInteger(), pointerType.getElementType());
      } else if(value instanceof ConstantPointer) {
         return new ConstantPointer(((ConstantPointer) value).getLocation(), pointerType.getElementType());
      }  else if(value instanceof ConstantString){
         throw new ConstantNotLiteral("Constant string not literal");
      }
      throw new InternalError("Calculation not implemented " + getOperator() + " " + value);
   }

   @Override
   public SymbolType inferType(SymbolType operandType) {
      return pointerType;
   }

   public SymbolTypePointer getPointerType() {
      return pointerType;
   }
}
