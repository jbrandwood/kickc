package dk.camelot64.kickc.model;

/** A reference to a scope */
public class ScopeRef extends SymbolRef {

   /** The ROOT scope of the program. */
   public static final ScopeRef ROOT = new ScopeRef("");

   public ScopeRef(String fullName) {
      super(fullName);
   }

   public ScopeRef(Scope scope) {
      super(scope.getFullName());
   }

}
