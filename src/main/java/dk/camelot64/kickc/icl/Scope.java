package dk.camelot64.kickc.icl;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.*;

/**
 * Manages symbols (variables, labels)
 */
public abstract class Scope implements Symbol {

   private String name;
   private HashMap<String, Symbol> symbols;
   private int intermediateVarCount = 0;
   private int intermediateLabelCount = 1;
   @JsonIgnore
   private Scope parentScope;

   public Scope(String name, Scope parentScope) {
      this.name = name;
      this.parentScope = parentScope;
      this.symbols = new LinkedHashMap<>();
   }

   @JsonCreator
   public Scope(
         @JsonProperty("name")  String name,
         @JsonProperty("symbols") HashMap<String, Symbol> symbols,
         @JsonProperty("intermediateVarCount") int intermediateVarCount,
         @JsonProperty("intermediateLabelCount") int intermediateLabelCount) {
      this.name = name;
      this.symbols = symbols;
      this.intermediateVarCount = intermediateVarCount;
      this.intermediateLabelCount = intermediateLabelCount;
      for (Symbol symbol : symbols.values()) {
         symbol.setScope(this);
      }
   }

   public Scope() {
      this.name = "";
      this.parentScope = null;
      this.symbols = new LinkedHashMap<>();
   }

   public HashMap<String, Symbol> getSymbols() {
      return symbols;
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
      if (symbol.getScope() != null) {
         String scopeName = symbol.getScope().getFullName();
         if (scopeName.length() > 0) {
            return scopeName + "::" + symbol.getLocalName();
         }
      }
      return symbol.getLocalName();
   }

   public ScopeRef getRef() {
      return new ScopeRef(this);
   }

   @Override
   @JsonIgnore
   public Scope getScope() {
      return parentScope;
   }

   @Override
   @JsonIgnore
   public abstract SymbolType getType();

   @Override
   @JsonIgnore
   public int getScopeDepth() {
      if (parentScope == null) {
         return 0;
      } else {
         return parentScope.getScopeDepth() + 1;
      }
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

   public Symbol getSymbol(SymbolRef symbolRef) {
      return getSymbol(symbolRef.getFullName());
   }

   public Symbol getSymbol(String name) {
      int pos = name.indexOf("::");
      if (pos >= 0) {
         String scopeName = name.substring(0, pos);
         String rest = name.substring(pos + 2);
         Symbol scopeSym = getSymbol(scopeName);
         if (scopeSym instanceof Scope) {
            return ((Scope) scopeSym).getSymbol(rest);
         } else {
            return null;
            //throw new RuntimeException("Error looking up symbol " + name);
         }
      } else {
         Symbol symbol = symbols.get(name);
         if(symbol==null) {
            if(parentScope!=null) {
               symbol = parentScope.getSymbol(name);
            }
         }
         return symbol;
      }
   }

   public Variable getVariable(String name) {
      return (Variable) getSymbol(name);
   }

   public Variable getVariable(VariableRef variableRef) {
      return getVariable(variableRef.getFullName());
   }

   @JsonIgnore
   public Collection<Variable> getAllVariables(boolean includeSubScopes) {
      Collection<Variable> vars = new ArrayList<>();
      for (Symbol symbol : symbols.values()) {
         if (symbol instanceof Variable) {
            vars.add((Variable) symbol);
         }
         if(includeSubScopes && symbol instanceof Scope) {
            Scope subScope = (Scope) symbol;
            vars.addAll(subScope.getAllVariables(true));
         }

      }
      return vars;
   }

   /**
    * Get all scopes contained in the scope. This does not include this scope itself.
    * @param includeSubScopes Include sub-scopes og sub-scopes
    * @return The scopes
    */
   @JsonIgnore
   public Collection<Scope> getAllScopes(boolean includeSubScopes) {
      Collection<Scope> scopes = new ArrayList<>();
      for (Symbol symbol : symbols.values()) {
         if (symbol instanceof Scope) {
            scopes.add((Scope) symbol);
            if(includeSubScopes) {
               Scope subScope = (Scope) symbol;
               scopes.addAll(subScope.getAllScopes(true));
            }
         }
      }
      return scopes;
   }

   public Collection<Procedure> getAllProcedures(boolean includeSubScopes) {
      Collection<Procedure> procedures = new ArrayList<>();
      for (Scope scope : getAllScopes(includeSubScopes)) {
         if(scope instanceof Procedure) {
            procedures.add((Procedure) scope);
         }
      }
      return procedures;
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

   public Label getLabel(LabelRef labelRef) {
      return (Label) getSymbol(labelRef);
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
      Symbol symbol = getSymbol(name);
      if (symbol != null && symbol instanceof Procedure) {
         return (Procedure) symbol;
      } else {
         return null;
      }
   }

   public Scope getScope(ScopeRef scopeRef) {
      if(scopeRef.getFullName().equals("") && this instanceof ProgramScope) {
         // Special case for the outer program scope
         return this;
      }
      Symbol symbol = getSymbol(scopeRef);
      if(symbol instanceof Scope) {
         return (Scope) symbol;
      } else {
         return null;
      }
   }


   public Procedure getProcedure(ProcedureRef ref) {
         return (Procedure) getSymbol(ref);
   }

   @JsonIgnore
   public String getSymbolTableContents(Program program, Class symbolClass) {
      VariableRegisterWeights registerWeights = program.getVariableRegisterWeights();
      StringBuilder res = new StringBuilder();
      Set<String> names = symbols.keySet();
      List<String> sortedNames = new ArrayList<>(names);
      Collections.sort(sortedNames);
      for (String name : sortedNames) {
         Symbol symbol = symbols.get(name);
         if (symbol instanceof Scope) {
            res.append(((Scope) symbol).getSymbolTableContents(program, symbolClass));
         } else {
            if (symbolClass == null || symbolClass.isInstance(symbol)) {
               res.append(symbol.toString(program));
               if (symbol instanceof Variable) {
                  Registers.Register register = ((Variable) symbol).getAllocation();
                  if (register != null) {
                     res.append(" " + register);
                  }
               }
               if (symbol instanceof Variable && registerWeights != null) {
                  Double weight = registerWeights.getWeight(((Variable) symbol).getRef());
                  if (weight != null) {
                     res.append(" " + weight);
                  }
               }
               res.append("\n");
            }
         }
      }
      return res.toString();
   }

   @JsonIgnore
   public Collection<Symbol> getAllSymbols() {
      return symbols.values();
   }

   @Override
   public void setScope(Scope scope) {
      this.parentScope = scope;
   }

   @Override
   public boolean equals(Object o) {
      if (this == o) {
         return true;
      }
      if (o == null || getClass() != o.getClass()) {
         return false;
      }

      Scope scope = (Scope) o;

      if (intermediateVarCount != scope.intermediateVarCount) {
         return false;
      }
      if (intermediateLabelCount != scope.intermediateLabelCount) {
         return false;
      }
      if (!name.equals(scope.name)) {
         return false;
      }
      if (!symbols.equals(scope.symbols)) {
         return false;
      }
      return true;
   }

   @Override
   public int hashCode() {
      int result = name.hashCode();
      result = 31 * result + intermediateVarCount;
      result = 31 * result + intermediateLabelCount;
      return result;
   }

}
