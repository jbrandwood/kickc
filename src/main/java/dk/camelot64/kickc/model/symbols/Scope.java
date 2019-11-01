package dk.camelot64.kickc.model.symbols;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.InternalError;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.Registers;
import dk.camelot64.kickc.model.VariableRegisterWeights;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.*;

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

   public <T extends Symbol> T add(T symbol) {
      if(symbols.get(symbol.getLocalName()) != null) {
         throw new CompileError("Symbol already declared " + symbol.getLocalName());
      }
      symbols.put(symbol.getLocalName(), symbol);
      return symbol;
   }

   public void remove(Symbol symbol) {
      symbols.remove(symbol.getLocalName());
   }

   public Variable addVariablePhiMaster(String name, SymbolType type, Variable.MemoryArea memoryArea, String dataSegment) {
      return add(new Variable( name, this, type, Variable.StorageStrategy.PHI_MASTER, memoryArea, dataSegment));
   }

   public Variable addVariableIntermediate() {
      String name = allocateIntermediateVariableName();
      return add(new Variable( name, this, SymbolType.VAR, Variable.StorageStrategy.INTERMEDIATE, Variable.MemoryArea.ZEROPAGE_MEMORY, getSegmentData()));
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
            if(variable.isVariable() && variable.isStoragePhiVersion() && variable.getVersionOf().equals(unversioned)) {
               versions.add(variable);
            }
         }
      }
      return versions;
   }

   public String allocateIntermediateVariableName() {
      return "$" + intermediateVarCount++;
   }

   public Symbol getSymbol(SymbolRef symbolRef) {
      return getSymbol(symbolRef.getFullName());
   }

   public Symbol getSymbol(String name) {
      int pos = name.indexOf("::");
      if(pos >= 0) {
         String scopeName = name.substring(0, pos);
         String rest = name.substring(pos + 2);
         Symbol scopeSym = getSymbol(scopeName);
         if(scopeSym instanceof Scope) {
            return ((Scope) scopeSym).getSymbol(rest);
         } else {
            return null;
            //throw new RuntimeException("Error looking up symbol " + name);
         }
      } else {
         Symbol symbol = symbols.get(name);
         if(symbol == null) {
            if(parentScope != null) {
               symbol = parentScope.getSymbol(name);
            }
         }
         return symbol;
      }
   }

   public Symbol getLocalSymbol(String name) {
      return symbols.get(name);
   }

   public Variable getVariable(String name) {
      Variable symbol = (Variable) getSymbol(name);
      if(symbol!=null && !symbol.isVariable()) throw new InternalError("Symbol is not a variable! "+symbol.toString());
      return symbol;
   }

   public Variable getVariable(SymbolVariableRef variableRef) {
      return getVariable(variableRef.getFullName());
   }

   public Variable getConstant(String name) {
      Variable symbol = (Variable) getSymbol(name);
      if(symbol!=null && !symbol.isConstant()) throw new InternalError("Symbol is not a constant! "+symbol.toString());
      return symbol;
   }

   public Variable getConstant(ConstantRef constantRef) {
      return getConstant(constantRef.getFullName());
   }

   public Collection<Variable> getAllSymbolVariables(boolean includeSubScopes) {
      Collection<Variable> vars = new ArrayList<>();
      for(Symbol symbol : symbols.values()) {
         if(symbol instanceof Variable) {
            vars.add((Variable) symbol);
         }
         if(includeSubScopes && symbol instanceof Scope) {
            Scope subScope = (Scope) symbol;
            vars.addAll(subScope.getAllSymbolVariables(true));
         }
      }
      return vars;
   }

   public Collection<Variable> getAllVariables(boolean includeSubScopes) {
      Collection<Variable> variables = getAllSymbolVariables(includeSubScopes);
      Collection<Variable> vars = new ArrayList<>();
      variables.stream().
            filter(Variable::isVariable).
            forEach(vars::add);
      return vars;
   }

   public Collection<Variable> getAllConstants(boolean includeSubScopes) {
      Collection<Variable> variables = getAllSymbolVariables(includeSubScopes);
      Collection<Variable> vars = new ArrayList<>();
      variables.stream().
            filter(Variable::isConstant).
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


   public Label addLabel(String name) {
      return add(new Label(name, this, false));
   }

   public Label addLabelIntermediate() {
      String name = "@" + intermediateLabelCount++;
      return add(new Label(name, this, true));
   }

   public Label getLabel(String name) {
      return (Label) getSymbol(name);
   }

   public Label getLabel(LabelRef labelRef) {
      return (Label) getSymbol(labelRef);
   }

   public BlockScope addBlockScope() {
      String name = ":" + blockCount++;
      return add(new BlockScope(name, this));
   }

   public BlockScope getBlockScope(String name) {
      return (BlockScope) getSymbol(name);
   }

   public Procedure addProcedure(String name, SymbolType type, String codeSegment, String dataSegment, Procedure.CallingConvension callingConvension) {
      return add(new Procedure(name, type, this, codeSegment, dataSegment, callingConvension));
   }

   public Procedure getProcedure(String name) {
      Symbol symbol = getSymbol(name);
      if(symbol != null && symbol instanceof Procedure) {
         return (Procedure) symbol;
      } else {
         return null;
      }
   }

   /**
    * Add a struct definition.
    * The name can be either defined in the program or an intermediate name.
    *
    * @param name
    */
   public StructDefinition addStructDefinition(String name) {
      return add(new StructDefinition(name, this));
   }

   public StructDefinition getStructDefinition(String name) {
      return (StructDefinition) getSymbol(name);
   }

   public EnumDefinition getEnumDefinition(String name) {
      return (EnumDefinition) getSymbol(name);
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

   public String toString(Program program, boolean onlyVars) {
      VariableRegisterWeights registerWeights = program.getOrNullVariableRegisterWeights();
      StringBuilder res = new StringBuilder();
      Set<String> names = symbols.keySet();
      List<String> sortedNames = new ArrayList<>(names);
      Collections.sort(sortedNames);
      for(String name : sortedNames) {
         Symbol symbol = symbols.get(name);
         if(symbol instanceof Scope) {
            // Always output scopes
            res.append(((Scope) symbol).toString(program, onlyVars));
         } else if(symbol instanceof Variable) {
            Variable symVar = (Variable) symbol;
            if(!onlyVars || symVar.isVariable()) {
               // Output if not instructed to only output variables - or if it is a variable
               res.append(symbol.toString(program));
               if(symVar.getAsmName() != null && !symVar.getName().equals(symVar.getAsmName())) {
                  res.append(" " + symVar.getAsmName());
               }
               if(symVar.isStorageLoadStore()) {
                  res.append(" notregister");
               }
               Registers.Register declRegister = symVar.getDeclaredRegister();
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
               if(symVar.isConstant()) {
                  res.append(" = " + symVar.getConstantValue().toString(program));
               }
               res.append("\n");
            }
         } else if(!onlyVars) {
            // Only output if not instructed to only output variables
            res.append(symbol.toString(program));
            res.append("\n");
         }
      }
      return res.toString();
   }

   public Collection<Symbol> getAllSymbols() {
      return symbols.values();
   }

   /**
    * Set the value of the counter used to number intermediate labels
    *
    * @param intermediateLabelCount The new counter value
    */
   public void setIntermediateLabelCount(int intermediateLabelCount) {
      this.intermediateLabelCount = intermediateLabelCount;
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
