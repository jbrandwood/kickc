package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.types.SymbolTypeStruct;

/**
 * An zero-filled struct.
 */
public class StructZero implements RValue {

   private SymbolTypeStruct typeStruct;

   public StructZero(SymbolTypeStruct typeStruct) {
      this.typeStruct = typeStruct;
   }

   public SymbolTypeStruct getTypeStruct() {
      return typeStruct;
   }

   @Override
   public String toString(Program program) {
      return "{}";
   }
}
