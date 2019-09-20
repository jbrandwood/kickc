package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.types.SymbolType;

/** A value pushed to the stack. */
public class ParamStackPush implements LValue {

   /** The type of value being pushed. */
   private SymbolType type;

   public ParamStackPush(SymbolType type) {
      this.type = type;
   }

   public SymbolType getType() {
      return type;
   }

   @Override
   public String toString(Program program) {
      return "paramstackpush(" + type.getTypeName()+ ")";
   }
}
