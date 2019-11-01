package dk.camelot64.kickc.model;

import dk.camelot64.kickc.model.symbols.Symbol;
import dk.camelot64.kickc.model.symbols.SymbolVariable;
import dk.camelot64.kickc.model.values.SymbolRef;
import dk.camelot64.kickc.model.values.VariableRef;

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

   public SymbolVariable getVariable(VariableRef ref) {
      return (SymbolVariable) getSymbol(ref);
   }

}
