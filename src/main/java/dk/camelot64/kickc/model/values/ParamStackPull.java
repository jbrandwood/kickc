package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.types.SymbolType;

/** A value puslled from the stack. */
public class ParamStackPull implements RValue {

   /** The type of value being pushed. */
   private SymbolType type;

   public ParamStackPull(SymbolType type) {
      this.type = type;
   }

   public SymbolType getType() {
      return type;
   }

   @Override
   public String toString(Program program) {
      return "paramstackpull(" + type.getTypeName()+ ")";
   }
}
