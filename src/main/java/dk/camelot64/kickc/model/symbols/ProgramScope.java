package dk.camelot64.kickc.model.symbols;

import dk.camelot64.kickc.model.LiveRangeEquivalenceClass;
import dk.camelot64.kickc.model.LiveRangeEquivalenceClassSet;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeProgram;
import dk.camelot64.kickc.model.values.*;

import java.util.Arrays;
import java.util.Deque;
import java.util.LinkedList;

/** The program scope containing the symbols of a program */
public class ProgramScope extends Scope {


   public ProgramScope() {
      super("", null, Scope.SEGMENT_DATA_DEFAULT);
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
      final Deque<String> names = new LinkedList<>(Arrays.asList(fullName.split("::")));
      Scope scope = this;
      while(names.size() > 1) {
         final String localName = names.removeFirst();
         scope = scope.getLocalScope(localName);
         if(scope == null)
            return null;
      }
      return scope.getLocalSymbol(names.removeFirst());
   }

   public Symbol getSymbol(SymbolRef symbolRef) {
      return getProgramScope().getGlobalSymbol(symbolRef.getFullName());
   }

   public Variable getVar(SymbolVariableRef variableRef) {
      return (Variable) getSymbol(variableRef);
   }

   public Variable getVariable(SymbolVariableRef variableRef) {
      return (Variable) getSymbol(variableRef);
   }

   public Variable getConstant(ConstantRef constantRef) {
      return (Variable) getSymbol(constantRef);
   }

   public Label getLabel(LabelRef labelRef) {
      return (Label) getSymbol(labelRef);
   }

   public Procedure getLocalProcedure(String name) {
      return (Procedure) getLocalSymbol(name);
   }

   public Procedure getProcedure(ProcedureRef procedureRef) {
      return (Procedure) getSymbol(procedureRef);
   }

   public Scope getScope(ScopeRef scopeRef) {
      if(scopeRef.getFullName().equals("")) {
         // Special case for the outer program scope
         return this;
      }
      return (Scope) getSymbol(scopeRef);
   }

   @Override
   public String toString(Program program, boolean onlyVars) {
      LiveRangeEquivalenceClassSet liveRangeEquivalenceClassSet = program.getLiveRangeEquivalenceClassSet();
      StringBuilder out = new StringBuilder();
      out.append(super.toString(program, onlyVars));
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
