package dk.camelot64.kickc.icl;

import java.util.*;

/**
 * Manages symbols (variables, labels)
 */
public class Scope implements Symbol {

   private String name;
   private SymbolType type;
   private Map<String, Symbol> symbols;
   private int intermediateVarCount = 0;
   private int intermediateLabelCount = 1;
   private RegisterAllocation allocation;
   private Scope parentScope;

   public Scope(String name, SymbolType type, Scope parentScope) {
      this.name = name;
      this.type = type;
      this.parentScope = parentScope;
      this.symbols = new LinkedHashMap<>();
   }

   public Scope() {
      this.name = "";
      this.type = new SymbolTypeProgram();
      this.parentScope = null;
      this.symbols = new LinkedHashMap<>();
   }

   @Override
   public String getLocalName() {
      return name;
   }

   @Override
   public String getFullName() {
      return getFullName(this);
   }

   public static String getFullName(Symbol symbol) {
      if(symbol.getScope()!=null) {
         String scopeName = symbol.getScope().getFullName();
         if(scopeName.length()>0) {
            return scopeName+"::"+symbol.getLocalName();
         }
      }
      return symbol.getLocalName();
   }


   @Override
   public Scope getScope() {
      return parentScope;
   }

   @Override
   public String getTypedName() {
      return "(" + getType().getTypeName() + ") " + getFullName();
   }

   @Override
   public SymbolType getType() {
      return type;
   }

   public Symbol add(Symbol symbol) {
      if (symbols.get(symbol.getLocalName()) != null) {
         throw new RuntimeException("Symbol already declared " + symbol.getLocalName());
      }
      symbols.put(symbol.getLocalName(), symbol);
      return symbol;
   }

   public void remove(Symbol symbol) {
      symbols.remove(symbol.getLocalName());
   }

   public VariableUnversioned addVariable(String name, SymbolType type) {
      VariableUnversioned symbol = new VariableUnversioned(name, this, type);
      add(symbol);
      return symbol;
   }

   public VariableIntermediate addVariableIntermediate() {
      String name = "$" + intermediateVarCount++;
      VariableIntermediate symbol = new VariableIntermediate(name, this, SymbolTypeBasic.VAR);
      add(symbol);
      return symbol;
   }

   public Variable getVariable(String name) {
      return (Variable) symbols.get(name);
   }

   public Collection<Variable> getAllVariables() {
      Collection<Variable> vars = new ArrayList<>();
      for (Symbol symbol : symbols.values()) {
         if (symbol instanceof Variable) {
            vars.add((Variable) symbol);
         }
      }
      return vars;
   }

   public Label addLabel(String name) {
      Label symbol = new Label(name, this, false);
      add(symbol);
      return symbol;
   }

   public Label addLabelIntermediate() {
      String name = "@" + intermediateLabelCount++;
      Label symbol = new Label(name, this, true);
      add(symbol);
      return symbol;
   }

   public Label getLabel(String name) {
      return (Label) symbols.get(name);
   }

   public Procedure addProcedure(String name, SymbolType type) {
      Symbol symbol = symbols.get(name);
      if (symbol != null) {
         throw new RuntimeException("Error! Symbol already defined " + symbol);
      }
      Procedure procedure = new Procedure(name, type, this);
      add(procedure);
      return procedure;
   }

   public Procedure getProcedure(String name) {
      Symbol symbol = symbols.get(name);
      if (symbol != null && symbol instanceof Procedure) {
         return (Procedure) symbol;
      } else {
         return null;
      }
   }

   public VariableVersion createVersion(VariableUnversioned symbol) {
      VariableVersion version = new VariableVersion(symbol, symbol.getNextVersionNumber());
      symbols.put(version.getLocalName(), version);
      return version;
   }

   public void setAllocation(RegisterAllocation allocation) {
      this.allocation = allocation;
   }

   public RegisterAllocation.Register getRegister(Variable variable) {
      RegisterAllocation.Register register = null;
      if (allocation != null) {
         register = allocation.getRegister(variable);
      }
      return register;
   }

   public String getSymbolTableContents() {
      StringBuilder res = new StringBuilder();
      Set<String> names = symbols.keySet();
      List<String> sortedNames = new ArrayList<>(names);
      Collections.sort(sortedNames);
      for (String name : sortedNames) {
         Symbol symbol = symbols.get(name);
         if (symbol instanceof Scope) {
            res.append(((Scope) symbol).getSymbolTableContents());
         } else {
            res.append(symbol.toString());
         }
         if (symbol instanceof Variable) {
            RegisterAllocation.Register register = getRegister((Variable) symbol);
            if (register != null) {
               res.append(" " + register);
            }
         }
         res.append("\n");
      }
      return res.toString();
   }

}
