package dk.camelot64.kickc.model.symbols;

import dk.camelot64.kickc.model.LiveRangeEquivalenceClass;
import dk.camelot64.kickc.model.LiveRangeEquivalenceClassSet;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeProgram;
import dk.camelot64.kickc.model.values.*;

import java.util.*;

/** The program scope containing the symbols of a program */
public class ProgramScope extends Scope {

   /** Caches the global symbols for fast lookup. */
   private Map<String, Symbol> cachedGlobalSymbols;

   public ProgramScope() {
      super("", null, Scope.SEGMENT_DATA_DEFAULT);
      cachedGlobalSymbols = new HashMap<>();
   }

   public void clearCache() {
      this.cachedGlobalSymbols = new HashMap<>();
   }

   @Override
   public SymbolType getType() {
      return new SymbolTypeProgram();
   }

   /**
    * Get a symbol from it's full name.
    *
    * @param fullName The full '::'-separated symbol name.
    * @return The symbol. Null if not found.
    */
   public Symbol getGlobalSymbol(String fullName) {
      final Symbol cachedSymbol = cachedGlobalSymbols.get(fullName);
      if(cachedSymbol != null)
         return cachedSymbol;
      final Deque<String> names = new LinkedList<>(Arrays.asList(fullName.split("::")));
      Scope scope = this;
      while(names.size() > 1) {
         final String localName = names.removeFirst();
         scope = scope.getLocalScope(localName);
         if(scope == null)
            return null;
      }
      final Symbol symbol = scope.getLocalSymbol(names.removeFirst());
      if(symbol != null)
         cachedGlobalSymbols.put(fullName, symbol);
      return symbol;
   }

   public Symbol getSymbol(SymbolRef symbolRef) {
      return this.getGlobalSymbol(symbolRef.getFullName());
   }

   public Variable getVar(SymbolVariableRef variableRef) {
      final Symbol symbol = getSymbol(variableRef);
      if(symbol!=null && !(symbol instanceof Variable)) return null;
      return (Variable) symbol;
   }

   public Variable getVariable(SymbolVariableRef variableRef) {
      final Symbol symbol = getSymbol(variableRef);
      if(symbol!=null && !(symbol instanceof Variable)) return null;
      return (Variable) symbol;
   }

   public Variable getConstant(ConstantRef constantRef) {
      return (Variable) getSymbol(constantRef);
   }

   public Label getLabel(LabelRef labelRef) {
      final Symbol symbol = getSymbol(labelRef);
      if(symbol!=null && !(symbol instanceof Label)) return null;
      return (Label) symbol;
   }

   public Procedure getLocalProcedure(String name) {
      final Symbol symbol = getLocalSymbol(name);
      if(symbol!=null && !(symbol instanceof Procedure)) return null;
      return (Procedure) symbol;
   }

   public Procedure getProcedure(ProcedureRef procedureRef) {
      final Symbol symbol = getSymbol(procedureRef);
      if(symbol!=null && !(symbol instanceof Procedure)) return null;
      return (Procedure) symbol;
   }

   /**
    * Add a struct definition.
    * The name can be either defined in the program or an intermediate name.
    *
    * @param name The name of the struct definition
    */
   public StructDefinition addStructDefinition(String name, boolean isUnion) {
      return add(new StructDefinition(name, isUnion, this));
   }

   public Scope getScope(ScopeRef scopeRef) {
      if(scopeRef.getFullName().equals("")) {
         // Special case for the outer program scope
         return this;
      }
      final Symbol symbol = getSymbol(scopeRef);
      if(symbol!=null && !(symbol instanceof Scope)) return null;
      return (Scope) symbol;
   }

   @Override
   public String toStringVars(Program program, boolean onlyVars) {
      LiveRangeEquivalenceClassSet liveRangeEquivalenceClassSet = program.getLiveRangeEquivalenceClassSet();
      StringBuilder out = new StringBuilder();
      out.append(super.toStringVars(program, onlyVars));
      if(liveRangeEquivalenceClassSet != null) {
         out.append("\n");
         for(LiveRangeEquivalenceClass liveRangeEquivalenceClass : liveRangeEquivalenceClassSet.getEquivalenceClasses()) {
            out.append(liveRangeEquivalenceClass.toString());
            out.append("\n");
         }
      }
      return out.toString();
   }

   @Override
   public String toString(Program program) {
      return "program";
   }

   /** The scope holding typedefs. */
   private TypeDefsScope typeDefsScope = new TypeDefsScope(ScopeRef.TYPEDEFS.getFullName(), this);

   public Scope getTypeDefScope() {
      return typeDefsScope;
   }

   /**
    * Get information about the size of the program
    *
    * @return Size information
    */
   public String getSizeInfo() {
      StringBuilder sizeInfo = new StringBuilder();
      sizeInfo.append("SIZE procedures " + getAllProcedures(true).size()).append("\n");
      sizeInfo.append("SIZE scopes " + getAllScopes(true).size()).append("\n");
      sizeInfo.append("SIZE variables " + getAllVariables(true).size()).append("\n");
      sizeInfo.append("SIZE constants  " + getAllConstants(true).size()).append("\n");
      return sizeInfo.toString();
   }

}
