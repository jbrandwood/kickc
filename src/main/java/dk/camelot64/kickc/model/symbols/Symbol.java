package dk.camelot64.kickc.model.symbols;

import dk.camelot64.kickc.model.values.SymbolRef;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.Value;

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
