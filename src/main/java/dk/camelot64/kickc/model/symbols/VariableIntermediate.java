package dk.camelot64.kickc.model.symbols;

import dk.camelot64.kickc.model.types.SymbolType;

/**
 * A Symbol (variable, jump label, etc.)
 */
public class VariableIntermediate extends Variable {

   public VariableIntermediate(String name, Scope scope, SymbolType type, String dataSegment) {
      super(name, scope, type, dataSegment);
   }

   @Override
   public boolean isVersioned() {
      return false;
   }


}
