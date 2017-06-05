package dk.camelot64.kickc.icl;

/** A Symbol (variable, jump label, etc.) */
public interface Symbol extends Value {

   String getLocalName();

   String getFullName();

   String getTypedName();

   SymbolType getType();

   Scope getScope();


}
