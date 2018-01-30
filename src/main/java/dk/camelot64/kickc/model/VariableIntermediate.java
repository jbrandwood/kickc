package dk.camelot64.kickc.model;

/**
 * A Symbol (variable, jump label, etc.)
 */
public class VariableIntermediate extends Variable {

   public VariableIntermediate(String name, Scope scope, SymbolType type) {
      super(name, scope, type);
   }

   @Override
   public boolean isVersioned() {
      return false;
   }


}
