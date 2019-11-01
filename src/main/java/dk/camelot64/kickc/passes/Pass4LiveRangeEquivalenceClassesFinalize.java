package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.statements.StatementCall;
import dk.camelot64.kickc.model.statements.StatementCallFinalize;
import dk.camelot64.kickc.model.symbols.SymbolVariable;
import dk.camelot64.kickc.model.values.VariableRef;

import java.util.ArrayList;
import java.util.List;

/**
 * Finalize live range equivalence classes ensuring that all variables is in an equivalence class
 */
public class Pass4LiveRangeEquivalenceClassesFinalize extends Pass2Base {

   public Pass4LiveRangeEquivalenceClassesFinalize(Program program) {
      super(program);
   }

   public void allocate() {

      // Initial equivalence classes from phi statements
      Pass3PhiMemCoalesce.EquivalenceClassPhiInitializer equivalenceClassPhiInitializer = new Pass3PhiMemCoalesce.EquivalenceClassPhiInitializer(getProgram());
      equivalenceClassPhiInitializer.visitGraph(getGraph());
      LiveRangeEquivalenceClassSet liveRangeEquivalenceClassSet = equivalenceClassPhiInitializer.getPhiEquivalenceClasses();
      getLog().append("Initial phi equivalence classes");
      for(LiveRangeEquivalenceClass liveRangeEquivalenceClass : liveRangeEquivalenceClassSet.getEquivalenceClasses()) {
         getLog().append(liveRangeEquivalenceClass.toString());
      }


      // Add all versions of volatile variables to the same equivalence class
      for(SymbolVariable variable : getSymbols().getAllVariables(true)) {
         if(variable.isStoragePhiVersion() && variable.isVolatile()) {
            // Found a volatile non-versioned variable
            for(SymbolVariable otherVariable : variable.getScope().getAllVariables(false)) {
               if(otherVariable.isStoragePhiVersion()) {
                  if((otherVariable).getVersionOf().equals((variable).getVersionOf())) {
                     // They share the same main variable
                     LiveRangeEquivalenceClass varEC = liveRangeEquivalenceClassSet.getOrCreateEquivalenceClass((VariableRef) variable.getRef());
                     LiveRangeEquivalenceClass otherEC = liveRangeEquivalenceClassSet.getOrCreateEquivalenceClass((VariableRef) otherVariable.getRef());
                     if(!varEC.equals(otherEC)) {
                        getLog().append("Coalescing volatile variable equivalence classes " + varEC.toString() + " and " + otherEC.toString());
                        liveRangeEquivalenceClassSet.consolidate(varEC, otherEC);
                     }
                  }
               }
            }
         }
      }


      // Add all other variables one by one to an available equivalence class - or create a new one
      EquivalenceClassAdder equivalenceClassAdder = new EquivalenceClassAdder(liveRangeEquivalenceClassSet);
      equivalenceClassAdder.visitGraph(getGraph());
      getLog().append("Complete equivalence classes");
      for(LiveRangeEquivalenceClass liveRangeEquivalenceClass : liveRangeEquivalenceClassSet.getEquivalenceClasses()) {
         getLog().append(liveRangeEquivalenceClass.toString());
      }

      getProgram().setLiveRangeEquivalenceClassSet(liveRangeEquivalenceClassSet);
   }

   /**
    * Add all variables to a non-overlapping equivalence or create a new one.
    */
   private class EquivalenceClassAdder extends ControlFlowGraphBaseVisitor<Void> {

      private LiveRangeEquivalenceClassSet liveRangeEquivalenceClassSet;

      EquivalenceClassAdder(LiveRangeEquivalenceClassSet liveRangeEquivalenceClassSet) {
         this.liveRangeEquivalenceClassSet = liveRangeEquivalenceClassSet;
      }

      @Override
      public Void visitAssignment(StatementAssignment assignment) {
         if(assignment.getlValue() instanceof VariableRef) {
            VariableRef lValVar = (VariableRef) assignment.getlValue();
            List<VariableRef> preferences = new ArrayList<>();
            addToEquivalenceClassSet(lValVar, preferences);
         }
         return null;
      }

      @Override
      public Void visitCall(StatementCall call) {
         if(call.getlValue() instanceof VariableRef) {
            VariableRef lValVar = (VariableRef) call.getlValue();
            List<VariableRef> preferences = new ArrayList<>();
            addToEquivalenceClassSet(lValVar, preferences);
         }
         return null;
      }

      @Override
      public Void visitCallFinalize(StatementCallFinalize callFinalize) {
         if(callFinalize.getlValue() instanceof VariableRef) {
            VariableRef lValVar = (VariableRef) callFinalize.getlValue();
            List<VariableRef> preferences = new ArrayList<>();
            addToEquivalenceClassSet(lValVar, preferences);
         }
         return null;
      }

      private void addToEquivalenceClassSet(VariableRef lValVar, List<VariableRef> preferences) {
         LiveRangeVariables liveRangeVariables = getProgram().getLiveRangeVariables();
         LiveRangeEquivalenceClass lValEquivalenceClass =
               liveRangeEquivalenceClassSet.getEquivalenceClass(lValVar);
         if(lValEquivalenceClass == null) {
            LiveRange lValLiveRange = liveRangeVariables.getLiveRange(lValVar);
            // Variable in need of an equivalence class - Look through preferences
            LiveRangeEquivalenceClass chosen = null;
            for(VariableRef preference : preferences) {
               LiveRangeEquivalenceClass preferenceEquivalenceClass = liveRangeEquivalenceClassSet.getEquivalenceClass(preference);
               if(preferenceEquivalenceClass != null) {
                  SymbolVariable potentialVariable = getProgram().getSymbolInfos().getVariable(preference);
                  SymbolVariable lValVariable = getProgram().getSymbolInfos().getVariable(lValVar);
                  if(lValVariable.getType().equals(potentialVariable.getType())) {
                     if(!lValLiveRange.overlaps(preferenceEquivalenceClass.getLiveRange())) {
                        chosen = preferenceEquivalenceClass;
                        chosen.addVariable(lValVar);
                        break;
                     }
                  }
               }
            }
            if(chosen == null) {
               // No preference usable - create a new one
               chosen = liveRangeEquivalenceClassSet.getOrCreateEquivalenceClass(lValVar);
            }
            getLog().append("Added variable " + lValVar + " to zero page equivalence class " + chosen);
         }
      }

   }

}
