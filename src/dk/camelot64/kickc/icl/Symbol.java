package dk.camelot64.kickc.icl;

/** A Symbol (variable, jump label, etc.) */
public interface Symbol extends Value {

   public String getName();

   public SymbolType getType();

}
