package dk.camelot64.kickc.icl;

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

   @JsonIgnore
   int getScopeDepth();

   void setScope(Scope scope);

   SymbolRef getRef();
}
