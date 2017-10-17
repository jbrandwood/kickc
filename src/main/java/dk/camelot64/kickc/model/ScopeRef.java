package dk.camelot64.kickc.model;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;

/**  A reference to a scope */
public class ScopeRef extends SymbolRef {

   /** The ROOT scope of the program. */
   public static final ScopeRef ROOT = new ScopeRef("");

   @JsonCreator
   public ScopeRef(
         @JsonProperty("fullName") String fullName) {
      super(fullName);
   }

   public ScopeRef(Scope scope) {
      super(scope.getFullName());
   }

}
