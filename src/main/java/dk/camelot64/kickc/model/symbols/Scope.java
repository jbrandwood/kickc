package dk.camelot64.kickc.model.symbols;

import dk.camelot64.kickc.model.InternalError;
import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.ScopeRef;

import java.io.Serializable;
import java.util.*;

/**
 * Manages symbols (variables, labels)
 */
public abstract class Scope implements Symbol, Serializable {

   /** The default code segment. */
   public static final String SEGMENT_CODE_DEFAULT = "Code";
   /** The default data segment. */
   public static final String SEGMENT_DATA_DEFAULT = "Data";

   private String name;
   private HashMap<String, Symbol> symbols;
   private int intermediateVarCount = 0;
   private int intermediateLabelCount = 1;
   private int blockCount = 1;
   private Scope parentScope;
   private String fullName;
   private String segmentData;

   public Scope(String name, Scope parentScope, String segmentData) {
      this.name = name;
      this.parentScope = parentScope;
      this.symbols = new LinkedHashMap<>();
      this.segmentData = segmentData;
      setFullName();
   }

   private void setFullName() {
      String scopeName = (parentScope == null) ? "" : parentScope.getFullName();
      fullName = (scopeName.length() > 0) ? scopeName + "::" + name : name;
   }

   public String getSegmentData() {
      return segmentData;
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
      return fullName;
   }

   public ScopeRef getRef() {
      return new ScopeRef(this);
   }

   @Override
   public Scope getScope() {
      return parentScope;
   }

   @Override
   public void setScope(Scope scope) {
      this.parentScope = scope;
      setFullName();
   }

   /**
    * Get the top-level program scope.
    *
    * @return The top-level scope. Null if not found.
    */
   public ProgramScope getProgramScope() {
      if(this instanceof ProgramScope)
         return (ProgramScope) this;
      else
         return parentScope.getProgramScope();
   }

   @Override
   public abstract SymbolType getType();

   @Override
   public int getScopeDepth() {
      if(parentScope == null) {
         return 0;
      } else {
         return parentScope.getScopeDepth() + 1;
      }
   }

   public void remove(Symbol symbol) {
      symbols.remove(symbol.getLocalName());
      getProgramScope().clearCache();
   }


   public <T extends Symbol> T add(T symbol) {
      if(symbols.get(symbol.getLocalName()) != null) {
         throw new CompileError("Symbol already declared " + symbol.getLocalName());
      }
      symbols.put(symbol.getLocalName(), symbol);
      return symbol;
   }

   public Label addLabel(String name) {
      return add(new Label(name, this, false));
   }

   public Label addLabelIntermediate() {
      String name = "@" + intermediateLabelCount++;
      return add(new Label(name, this, true));
   }


   public BlockScope addBlockScope() {
      String name = ":" + blockCount++;
      return add(new BlockScope(name, this));
   }

   public String allocateIntermediateVariableName() {
      return "$" + intermediateVarCount++;
   }

   /**
    * Set the value of the counter used to number intermediate labels
    *
    * @param intermediateLabelCount The new counter value
    */
   public void setIntermediateLabelCount(int intermediateLabelCount) {
      this.intermediateLabelCount = intermediateLabelCount;
   }

   /**
    * Get all versions of a PHI-master variable
    *
    * @param unversioned The unversioned PHI-master variable
    * @return All versions of the variable
    */
   public Collection<Variable> getVersions(Variable unversioned) {
      LinkedHashSet<Variable> versions = new LinkedHashSet<>();
      for(Symbol symbol : symbols.values()) {
         if(symbol instanceof Variable) {
            Variable variable = (Variable) symbol;
            if(variable.isVariable() && variable.isKindPhiVersion() && variable.getPhiMaster().equals(unversioned)) {
               versions.add(variable);
            }
         }
      }
      return versions;
   }

   /**
    * Get a local symbol by name. Does not search parent scopes.
    *
    * @param name The symbol name to look for
    * @return The symbol if found. null otherwise.
    */
   public Symbol getLocalSymbol(String name) {
      return symbols.get(name);
   }

   /**
    * Look for a symbol by it's (short) name. Looks through this scope first and then through any parent scope.
    *
    * @param name The symbol name
    * @return The found symbol. Null is not found.
    */
   public Symbol findSymbol(String name) {
      Symbol symbol = symbols.get(name);
      if(symbol == null) {
         if(parentScope != null) {
            symbol = parentScope.findSymbol(name);
         }
      }
      return symbol;
   }

   public Variable findVariable(String name) {
      final Symbol symbol = findSymbol(name);
      if(symbol!=null && !(symbol instanceof Variable))
         throw new InternalError("Symbol is not a variable! " + symbol.toString());
      return (Variable) symbol;
   }

   public Collection<Symbol> getAllSymbols() {
      return symbols.values();
   }

   /**
    * Get all variables/constants in the scope
    *
    * @param includeSubScopes true to include sub-scopes
    * @return all variables/constants
    */
   public Collection<Variable> getAllVars(boolean includeSubScopes) {
      Collection<Variable> vars = new ArrayList<>();
      for(Symbol symbol : symbols.values()) {
         if(symbol instanceof Variable) {
            vars.add((Variable) symbol);
         }
         if(includeSubScopes && symbol instanceof Scope) {
            Scope subScope = (Scope) symbol;
            vars.addAll(subScope.getAllVars(true));
         }
      }
      return vars;
   }

   /**
    * Get all runtime variables (excluding constants)
    *
    * @param includeSubScopes true to include sub-scopes
    * @return all runtime variables (excluding constants)
    */
   public Collection<Variable> getAllVariables(boolean includeSubScopes) {
      Collection<Variable> vars = new ArrayList<>();
      getAllVars(includeSubScopes).stream().
            filter(Variable::isVariable).
            forEach(vars::add);
      return vars;
   }

   /**
    * Get all constants
    *
    * @param includeSubScopes true to include sub-scopes
    * @return all constants
    */
   public Collection<Variable> getAllConstants(boolean includeSubScopes) {
      Collection<Variable> vars = new ArrayList<>();
      getAllVars(includeSubScopes).stream().
            filter(variable -> variable.isKindConstant()).
            forEach(vars::add);
      return vars;
   }

   /**
    * Get all scopes contained in the scope. This does not include this scope itself.
    *
    * @param includeSubScopes Include sub-scopes og sub-scopes
    * @return The scopes
    */
   public Collection<Scope> getAllScopes(boolean includeSubScopes) {
      Collection<Scope> scopes = new ArrayList<>();
      for(Symbol symbol : symbols.values()) {
         if(symbol instanceof Scope) {
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
      for(Scope scope : getAllScopes(includeSubScopes)) {
         if(scope instanceof Procedure) {
            procedures.add((Procedure) scope);
         }
      }
      return procedures;
   }

   public Collection<Symbol> getAllSymbols(boolean includeSubscopes) {
      ArrayList<Symbol> allSymbols = new ArrayList<>();
      for(Symbol symbol : symbols.values()) {
         allSymbols.add(symbol);
         if(symbol instanceof Scope && includeSubscopes) {
            allSymbols.addAll(((Scope) symbol).getAllSymbols(true));
         }
      }
      return allSymbols;
   }

   public Variable getLocalVar(String name) {
      final Symbol symbol = getLocalSymbol(name);
      if(symbol!=null && !(symbol instanceof Variable))
         throw new InternalError("Symbol is not a variable! " + symbol.toString());
      return (Variable) symbol;
   }

   public Variable getLocalVariable(String name) {
      final Variable var = getLocalVar(name);
      if(var != null && !var.isVariable())
         throw new InternalError("Symbol is not a variable! " + var.toString());
      return var;
   }

   public Variable getLocalConstant(String name) {
      final Variable var = getLocalVar(name);
      if(var != null && !var.isKindConstant())
         throw new InternalError("Symbol is not a constant! " + var.toString());
      return var;
   }

   public Label getLocalLabel(String name) {
      final Symbol symbol = getLocalSymbol(name);
      if(symbol!=null && !(symbol instanceof Label))
         throw new InternalError("Symbol is not a label! " + symbol.toString());
      return (Label) getLocalSymbol(name);
   }

   public BlockScope getLocalBlockScope(String name) {
      final Symbol symbol = getLocalSymbol(name);
      if(symbol!=null && !(symbol instanceof BlockScope))
         throw new InternalError("Symbol is not a block scope! " + symbol.toString());
      return (BlockScope) symbol;
   }

   public StructDefinition getLocalStructDefinition(String name) {
      final Symbol symbol = getLocalSymbol(name);
      if(symbol!=null && !(symbol instanceof StructDefinition))
         throw new InternalError("Symbol is not a struct definition! " + symbol.toString());
      return (StructDefinition) symbol;
   }

   public EnumDefinition getLocalEnumDefinition(String name) {
      final Symbol symbol = getLocalSymbol(name);
      if(symbol!=null && !(symbol instanceof EnumDefinition))
         throw new InternalError("Symbol is not an enum definition! " + symbol.toString());
      return (EnumDefinition) symbol;
   }

   public Scope getLocalScope(String name) {
      final Symbol symbol = getLocalSymbol(name);
      if(symbol!=null && !(symbol instanceof Scope))
         throw new InternalError("Symbol is not a scope! " + symbol.toString());
      return (Scope) symbol;
   }

   public String toString(Program program, boolean onlyVars) {
      VariableRegisterWeights registerWeights = program.getOrNullVariableRegisterWeights();
      StringBuilder res = new StringBuilder();
      Set<String> names = symbols.keySet();
      List<String> sortedNames = new ArrayList<>(names);
      Collections.sort(sortedNames);
      for(String name : sortedNames) {
         Symbol symbol = symbols.get(name);
         if(symbol instanceof Scope) {
            // Do not output struct definitions
            if(symbol instanceof StructDefinition )
               continue;
            if(!onlyVars || symbol instanceof Procedure ||  symbol instanceof BlockScope||  symbol instanceof ProgramScope)
               res.append(((Scope) symbol).toString(program, onlyVars));
         } else if(symbol instanceof Variable) {
            Variable symVar = (Variable) symbol;
            if(!onlyVars || symVar.isVariable()) {
               // Output if not instructed to only output variables - or if it is a variable
               res.append(symVar.typeString() + " " + symVar.toString());
               if(symVar.isArray()) {
                  res.append("[");
                  if(symVar.getArraySize() != null) {
                     res.append(symVar.getArraySize().toString(program));
                  }
                  res.append("] ");
               }
               if(symVar.getAsmName() != null && !symVar.getName().equals(symVar.getAsmName())) {
                  res.append(" " + symVar.getAsmName());
               }
               if(symVar.isKindLoadStore()) {
                  res.append(" loadstore");
               }
               Registers.Register declRegister = symVar.getRegister();
               if(declRegister != null) {
                  res.append(" !" + declRegister);
               }
               if(symVar.isVariable()) {
                  Registers.Register register = symVar.getAllocation();
                  if(register != null && !register.equals(declRegister)) {
                     res.append(" " + register);
                  }
                  if(registerWeights != null) {
                     Double weight = registerWeights.getWeight(symVar.getVariableRef());
                     if(weight != null) {
                        res.append(" " + weight);
                     }
                  }
               }
               if(symVar.getInitValue() != null) {
                  res.append(" = " + symVar.getInitValue().toString(program));
               }
               res.append("\n");
            }
         } else if(!onlyVars) {
            // Do not output labels
            if(symbol instanceof Label)
               continue;
            // Only output if not instructed to only output variables
            res.append(symbol.toString(program));
            res.append("\n");
         }
      }
      return res.toString();
   }

   @Override
   public boolean equals(Object o) {
      if(this == o) {
         return true;
      }
      if(o == null || getClass() != o.getClass()) {
         return false;
      }

      Scope scope = (Scope) o;

      if(intermediateVarCount != scope.intermediateVarCount) {
         return false;
      }
      if(intermediateLabelCount != scope.intermediateLabelCount) {
         return false;
      }
      if(!name.equals(scope.name)) {
         return false;
      }
      if(!symbols.equals(scope.symbols)) {
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
