package dk.camelot64.kickc.model;

import com.fasterxml.jackson.annotation.JsonIgnore;

/** A Symbol (variable, jump label, etc.) */
public interface Symbol extends Value {

   @JsonIgnore
   String getLocalName();

   @JsonIgnore
   String getFullName();

   SymbolType getType();

   @JsonIgnore
   Scope getScope();

   void setScope(Scope scope);

   @JsonIgnore
   int getScopeDepth();

   SymbolRef getRef();
}
