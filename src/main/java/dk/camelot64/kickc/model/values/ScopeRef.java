package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.symbols.Scope;

/** A reference to a scope */
public class ScopeRef extends SymbolRef {

   /** The ROOT scope of the program. */
   public static final ScopeRef ROOT = new ScopeRef("");

   /** The scope holding type definitions. */
   public static final ScopeRef TYPEDEFS = new ScopeRef("typedefs");

   public ScopeRef(String fullName) {
      super(fullName);
   }

   public ScopeRef(Scope scope) {
      super(scope.getFullName());
   }

}
