package dk.camelot64.kickc.model;

import java.util.Map;

/** Cached information about symbols. Contains a symbol table cache for fast access. */
public class SymbolInfos {

   private Map<SymbolRef, Symbol> symbols;

   public SymbolInfos(Map<SymbolRef, Symbol> symbols) {
      this.symbols = symbols;
   }

   public Symbol getSymbol(SymbolRef ref) {
      return symbols.get(ref);
   }

   public Variable getVariable(VariableRef ref) {
      return (Variable) getSymbol(ref);
   }

}
