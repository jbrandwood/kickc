package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.types.SymbolType;

/** Abstract cast operator. */
public abstract class OperatorCast extends OperatorUnary {

   private SymbolType toType;

   public OperatorCast(String operator, String asmOperator, int precedence, SymbolType toType) {
      super(operator, asmOperator, precedence);
      this.toType = toType;
   }

   public SymbolType getToType() {
      return toType;
   }
}
