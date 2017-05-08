package dk.camelot64.kickc.icl;

import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Manages symbols (variables, labels)
 */
public class SymbolManager {

   private Map<String, Symbol> symbols;
   private int intermediateVarCount = 0;
   private int intermediateLabelCount = 1;

   public SymbolManager() {
      this.symbols = new LinkedHashMap<>();
   }

   private Symbol addSymbol(String name, SymbolType symbolType, boolean intermediate) {
      if(symbols.get(name)!=null) {
         throw new RuntimeException("Symbol already declared "+name);
      }
      Symbol symbol = new Symbol(name, symbolType, intermediate);
      symbols.put(name, symbol);
      return symbol;
   }

   public void newVariableDeclaration(String name, String type) {
      SymbolType symbolType = SymbolType.get(type);
      addSymbol(name, symbolType, false);
   }

   public Symbol newVariableAssignment(String varName) {
      return symbols.get(varName);
   }

   public Symbol newVariableUsage(String varName) {
      return symbols.get(varName);
   }

   public Symbol newIntermediateAssignment() {
      String name = "$"+intermediateVarCount++;
      Symbol symbol = addSymbol(name, SymbolType.VAR, true);
      return symbol;
   }

   public Symbol newNamedJumpLabel(String name) {
      Symbol symbol = addSymbol(name, SymbolType.LABEL, false);
      return symbol;
   }

   public Symbol newIntermediateJumpLabel() {
      String name = "@"+   intermediateLabelCount++;
      Symbol symbol = addSymbol(name, SymbolType.LABEL, true);
      return symbol;
   }

   @Override
   public String toString() {
      StringBuffer out = new StringBuffer();
      for (String name : symbols.keySet()) {
         Symbol symbol = symbols.get(name);
         out.append(symbol.toString() + "\n");
      }
      return out.toString();
   }

   public void remove(Symbol symbol) {
      symbols.remove(symbol.getName());
   }

   public Symbol createVersion(Symbol symbol) {
      Symbol version = new Symbol(symbol, symbol.getNextVersionNumber());
      symbols.put(version.getName(), version);
      return version;
   }
}
