package dk.camelot64.kickc.icl;

import java.util.*;

/**
 * Manages symbols (variables, labels)
 */
public class SymbolTable {

   private Map<String, Symbol> symbols;
   private int intermediateVarCount = 0;
   private int intermediateLabelCount = 1;
   private RegisterAllocation allocation;

   public SymbolTable() {
      this.symbols = new LinkedHashMap<>();
   }

   public Collection<Variable> getAllVariables() {
      Collection<Variable> vars = new ArrayList<>();
      for (Symbol symbol : symbols.values()) {
         if(symbol instanceof Variable) {
            vars.add((Variable) symbol);
         }
      }
      return vars;
   }

   private Symbol addSymbol(Symbol symbol) {
      if(symbols.get(symbol.getName())!=null) {
         throw new RuntimeException("Symbol already declared "+symbol.getName());
      }
      symbols.put(symbol.getName(), symbol);
      return symbol;
   }

   public VariableUnversioned newVariableDeclaration(String name, String type) {
      SymbolType symbolType = SymbolType.get(type);
      VariableUnversioned symbol = new VariableUnversioned(name, symbolType);
      addSymbol(symbol);
      return symbol;
   }

   public VariableUnversioned newVariableUsage(String name) {
      return (VariableUnversioned) symbols.get(name);
   }

   public VariableIntermediate newIntermediateAssignment() {
      String name = "$"+intermediateVarCount++;
      VariableIntermediate symbol = new VariableIntermediate(name, SymbolType.VAR);
      addSymbol(symbol);
      return symbol;
   }

   public Label newNamedJumpLabel(String name) {
      Label symbol = new Label(name, false);
      addSymbol(symbol);
      return symbol;
   }

   public Label newIntermediateJumpLabel() {
      String name = "@"+   intermediateLabelCount++;
      Label symbol = new Label(name, true);
      addSymbol(symbol);
      return symbol;
   }

   public void remove(Symbol symbol) {
      symbols.remove(symbol.getName());
   }

   public VariableVersion createVersion(VariableUnversioned symbol) {
      VariableVersion version = new VariableVersion(symbol, symbol.getNextVersionNumber());
      symbols.put(version.getName(), version);
      return version;
   }

   public void setAllocation(RegisterAllocation allocation) {
      this.allocation = allocation;
   }

   public RegisterAllocation.Register getRegister(Variable variable) {
      RegisterAllocation.Register register = null;
      if(allocation!=null) {
         register = allocation.getRegister(variable);
      }
      return register;
   }

   @Override
   public String toString() {
      StringBuffer out = new StringBuffer();
      Set<String> names = symbols.keySet();
      List<String> sortedNames = new ArrayList<>(names);
      Collections.sort(sortedNames);
      for (String name : sortedNames) {
         Symbol symbol = symbols.get(name);
         out.append(symbol.toString());
         if(symbol instanceof Variable) {
            RegisterAllocation.Register register = getRegister((Variable) symbol);
            if(register!=null) {
               out.append(" "+register);
            }
         }
         out.append("\n");
      }
      return out.toString();
   }

}
