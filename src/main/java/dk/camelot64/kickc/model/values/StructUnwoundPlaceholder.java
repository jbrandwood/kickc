package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.types.SymbolTypeStruct;

/** Used as a placeholder value, where a struct has been unwound. */
public class StructUnwoundPlaceholder implements RValue {

   public StructUnwoundPlaceholder(SymbolTypeStruct typeStruct) {
      this.typeStruct = typeStruct;
   }

   /** The type of the struct. */
   private SymbolTypeStruct typeStruct;

   public SymbolTypeStruct getTypeStruct() {
      return typeStruct;
   }

   @Override
   public String toString(Program program) {
      return "struct-unwound";
   }

}
