package dk.camelot64.kickc.model;

/** A Symbol (variable, jump label, etc.) */
public interface Symbol extends Value {

   String getLocalName();

   String getFullName();

   SymbolType getType();

   Scope getScope();

   void setScope(Scope scope);

   int getScopeDepth();

   SymbolRef getRef();
}
