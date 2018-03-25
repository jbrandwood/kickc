package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeSimple;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;
import dk.camelot64.kickc.model.values.ConstantPointer;

/** Unary Cast to double word operator ( (dword) x ) */
public class OperatorCastDWord extends OperatorUnary {

   public OperatorCastDWord(int precedence) {
      super("((dword))", "_dword_", precedence);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral value) {
      if(value instanceof ConstantInteger) {
         return new ConstantInteger(0xffffffffL & ((ConstantInteger) value).getValue());
      }
      if(value instanceof ConstantPointer) {
         return new ConstantInteger(0xffff & ((ConstantPointer) value).getLocation());
      }
      throw new CompileError("Calculation not implemented " + getOperator() + " " + value );
   }


   @Override
   public SymbolType inferType(SymbolTypeSimple operandType) {
      return SymbolType.DWORD;
   }
}
