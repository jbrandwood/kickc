package dk.camelot64.kickc.passes;


import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.symbols.Scope;
import dk.camelot64.kickc.model.symbols.Symbol;
import dk.camelot64.kickc.model.values.SymbolRef;

import java.util.LinkedHashMap;

/** Create the symbol table cache */
public class Pass3SymbolInfos extends Pass2Base {

   public Pass3SymbolInfos(Program program) {
      super(program);
   }

   /**
    * Create map from statement index to block
    */
   public void generateSymbolInfos() {
      LinkedHashMap<SymbolRef, Symbol> symbolCache = new LinkedHashMap<>();
      ProgramScope scope = getProgram().getScope();
      generateCache(symbolCache, scope);
      SymbolInfos symbolInfos = new SymbolInfos(symbolCache);
      getProgram().setSymbolInfos(symbolInfos);

   }

   private void generateCache(LinkedHashMap<SymbolRef, Symbol> symbolCache, Scope scope) {
      for(Symbol symbol : scope.getAllSymbols()) {
         symbolCache.put(symbol.getRef(), symbol);
         if(symbol instanceof Scope) {
            generateCache(symbolCache, (Scope) symbol);
         }
      }
   }


}
