package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.statements.StatementCall;
import dk.camelot64.kickc.model.statements.StatementCallFinalize;
import dk.camelot64.kickc.model.symbols.StructDefinition;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.values.RValue;
import dk.camelot64.kickc.model.values.ValueList;
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
      for(Variable variable : getSymbols().getAllVariables(true)) {
         if(variable.isKindPhiVersion() && variable.isVolatile() && !variable.isStructUnwind()) {
            // Found a volatile non-versioned variable
            for(Variable otherVariable : variable.getScope().getAllVariables(false)) {
               if(otherVariable.isKindPhiVersion()) {
                  if((otherVariable).getPhiMaster().equals((variable).getPhiMaster())) {
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

      // Add any load/store variables with an initializer - and load/store struct  variables
      for(Variable variable : getSymbols().getAllVariables(true)) {
         if(variable.getScope() instanceof StructDefinition)
            continue;
         if(variable.isKindLoadStore() && variable.getInitValue()!=null)
            addToEquivalenceClassSet(variable.getVariableRef(), new ArrayList<>(), liveRangeEquivalenceClassSet);
         else if(variable.isStructClassic())
            addToEquivalenceClassSet(variable.getVariableRef(), new ArrayList<>(), liveRangeEquivalenceClassSet);
      }

      getLog().append("Complete equivalence classes");
      for(LiveRangeEquivalenceClass liveRangeEquivalenceClass : liveRangeEquivalenceClassSet.getEquivalenceClasses()) {
         getLog().append(liveRangeEquivalenceClass.toString());
      }

      getProgram().setLiveRangeEquivalenceClassSet(liveRangeEquivalenceClassSet);
   }

    void addToEquivalenceClassSet(VariableRef lValVar, List<VariableRef> preferences, LiveRangeEquivalenceClassSet liveRangeEquivalenceClassSet) {
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
               Variable potentialVariable = getProgram().getSymbolInfos().getVariable(preference);
               Variable lValVariable = getProgram().getSymbolInfos().getVariable(lValVar);
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
         getLog().append("Added variable " + lValVar + " to live range equivalence class " + chosen);
      }
   }

   /**
    * Add all variables to a non-overlapping equivalence or create a new one.
    */
   private class EquivalenceClassAdder extends GraphBaseVisitor<Void> {

      private LiveRangeEquivalenceClassSet liveRangeEquivalenceClassSet;

      EquivalenceClassAdder(LiveRangeEquivalenceClassSet liveRangeEquivalenceClassSet) {
         this.liveRangeEquivalenceClassSet = liveRangeEquivalenceClassSet;
      }

      @Override
      public Void visitAssignment(StatementAssignment assignment) {
         addValueToEquivalenceClassSet(assignment.getlValue());
         return null;
      }

      @Override
      public Void visitCall(StatementCall call) {
         addValueToEquivalenceClassSet(call.getlValue());
         return null;
      }

      @Override
      public Void visitCallFinalize(StatementCallFinalize callFinalize) {
         addValueToEquivalenceClassSet(callFinalize.getlValue());
         return null;
      }

      private void addValueToEquivalenceClassSet(RValue lValue) {
         if(lValue instanceof VariableRef) {
            VariableRef lValVar = (VariableRef) lValue;
            List<VariableRef> preferences = new ArrayList<>();
            addToEquivalenceClassSet(lValVar, preferences, liveRangeEquivalenceClassSet);
         } else if(lValue instanceof ValueList) {
            for(RValue rValue : ((ValueList) lValue).getList()) {
               addValueToEquivalenceClassSet(rValue);
            }
         }
      }

   }

}
