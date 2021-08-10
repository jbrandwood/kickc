package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.types.SymbolType;

/** A value pulled from the stack. */
public class StackPullValue implements RValue {

   /** The type of value being pushed. */
   private SymbolType type;

   public StackPullValue(SymbolType type) {
      this.type = type;
   }

   public SymbolType getType() {
      return type;
   }

   @Override
   public String toString(Program program) {
      return "stackpull(" + type.toCDecl() + ")";
   }
}
