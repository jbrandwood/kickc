package dk.camelot64.kickc.model.symbols;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeStruct;

/**
 * A struct definition containing a set of variables.
 */
public class StructDefinition extends Scope {

   public StructDefinition(String name, Scope parentScope) {
      super(name, parentScope);
   }

   @Override
   public SymbolType getType() {
      return new SymbolTypeStruct(this);
   }

   @Override
   public String toString(Program program) {
      return "block-"+getFullName();
   }
}
