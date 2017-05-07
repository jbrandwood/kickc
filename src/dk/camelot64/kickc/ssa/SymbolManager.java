package dk.camelot64.kickc.ssa;

import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Manages symbols (variables, labels)
 */
public class SymbolManager {

   private Map<String, Symbol> symbols;

   private int intermediateVarCount = 0;
   private int intermediateLabelCount = 0;

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

   public SSAJumpLabel newNamedJumpLabel(String name) {
      Symbol symbol = addSymbol(name, SymbolType.LABEL, false);
      return new SSAJumpLabel(name);
   }

   public SSAJumpLabel newIntermediateJumpLabel() {
      String name = "@"+   intermediateLabelCount++;
      addSymbol(name, SymbolType.LABEL, true);
      return new SSAJumpLabel(name);
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
}
