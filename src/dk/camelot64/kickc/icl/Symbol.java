package dk.camelot64.kickc.icl;

/** A Symbol (variable, jump label, etc.) */
public interface Symbol {

   public String getName();

   public SymbolType getType();

}
