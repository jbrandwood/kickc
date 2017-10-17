package dk.camelot64.kickc.model;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * A Symbol (variable, jump label, etc.)
 */
public class VariableIntermediate extends Variable {

   public VariableIntermediate(String name, Scope scope, SymbolType type) {
      super(name, scope, type);
   }

   @JsonCreator
   public VariableIntermediate(
         @JsonProperty("name") String name,
         @JsonProperty("type") SymbolType type) {
      super(name, null, type);
   }

   @Override
   public boolean isIntermediate() {
      return true;
   }

   @Override
   public boolean isVersioned() {
      return false;
   }


}
