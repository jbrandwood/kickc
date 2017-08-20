package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.icl.*;

import java.util.ArrayList;
import java.util.List;

/**
 * Zero Page Register Allocation for variables based on live ranges and phi equivalence classes.
 */
public class Pass4ZeroPageAllocation extends Pass2Base {

   public Pass4ZeroPageAllocation(Program program) {
      super(program);
   }

   public void allocate() {

      // Initial equivalence classes from phi statements
      Pass3PhiMemCoalesce.EquivalenceClassPhiInitializer equivalenceClassPhiInitializer = new Pass3PhiMemCoalesce.EquivalenceClassPhiInitializer(getProgram());
      equivalenceClassPhiInitializer.visitGraph(getGraph());
      LiveRangeEquivalenceClassSet liveRangeEquivalenceClassSet = equivalenceClassPhiInitializer.getPhiEquivalenceClasses();
      getLog().append("Initial phi equivalence classes");
      for (LiveRangeEquivalenceClass liveRangeEquivalenceClass : liveRangeEquivalenceClassSet.getEquivalenceClasses()) {
         getLog().append(liveRangeEquivalenceClass.toString());
      }

      // Add all other variables one by one to an available equivalence class - or create a new one
      EquivalenceClassAdder equivalenceClassAdder = new EquivalenceClassAdder(liveRangeEquivalenceClassSet);
      equivalenceClassAdder.visitGraph(getGraph());
      getLog().append("Complete equivalence classes");
      for (LiveRangeEquivalenceClass liveRangeEquivalenceClass : liveRangeEquivalenceClassSet.getEquivalenceClasses()) {
         getLog().append(liveRangeEquivalenceClass.toString());
      }

      // Allocate zeropage registers to equivalence classes
   //   for (LiveRangeEquivalenceClass liveRangeEquivalenceClass : liveRangeEquivalenceClassSet.getEquivalenceClasses()) {
   //      List<VariableRef> variables = liveRangeEquivalenceClass.getVariables();
   //      Variable firstVar = getProgram().getScope().getVariable(variables.get(0));
   //      RegisterAllocation.Register zpRegister = allocateNewRegisterZp(firstVar.getType());
   //      liveRangeEquivalenceClass.setRegister(zpRegister);
   //      getLog().append("Allocated " + zpRegister + " to " + liveRangeEquivalenceClass);
   //   }
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
         if (assignment.getlValue() instanceof VariableRef) {
            VariableRef lValVar = (VariableRef) assignment.getlValue();
            List<VariableRef> preferences = new ArrayList<>();
            addToEquivalenceClassSet(lValVar, preferences);
         }
         return null;
      }

      private void addToEquivalenceClassSet(VariableRef lValVar, List<VariableRef> preferences) {
         LiveRangeVariables liveRangeVariables = getProgram().getLiveRangeVariables();
         LiveRangeEquivalenceClass lValEquivalenceClass =
               liveRangeEquivalenceClassSet.getEquivalenceClass(lValVar);
         if (lValEquivalenceClass == null) {
            LiveRange lValLiveRange = liveRangeVariables.getLiveRange(lValVar);
            // Variable in need of an equivalence class - Look through preferences
            LiveRangeEquivalenceClass chosen = null;
            for (VariableRef preference : preferences) {
               LiveRangeEquivalenceClass preferenceEquivalenceClass = liveRangeEquivalenceClassSet.getEquivalenceClass(preference);
               if (preferenceEquivalenceClass != null) {
                  Variable potentialVariable = getProgram().getScope().getVariable(preference);
                  Variable lValVariable = getProgram().getScope().getVariable(lValVar);
                  if (lValVariable.getType().equals(potentialVariable.getType())) {
                     if (!lValLiveRange.overlaps(preferenceEquivalenceClass.getLiveRange())) {
                        chosen = preferenceEquivalenceClass;
                        chosen.addVariable(lValVar);
                        break;
                     }
                  }
               }
            }
            if (chosen == null) {
               // No preference usable - create a new one
               chosen = liveRangeEquivalenceClassSet.getOrCreateEquivalenceClass(lValVar);
            }
            getLog().append("Added variable " + lValVar + " to zero page equivalence class " + chosen);
         }
      }

   }

   /**
    * The current zero page used to create new registers when needed.
    */
   private int currentZp = 2;

   /**
    * Create a new register for a specific variable type.
    *
    * @param varType The variable type to create a register for.
    *                The register type created uses one or more zero page locations based on the variable type
    * @return The new zeropage register
    */
   private RegisterAllocation.Register allocateNewRegisterZp(SymbolType varType) {
      if (varType.equals(SymbolTypeBasic.BYTE)) {
         return new RegisterAllocation.RegisterZpByte(currentZp++);
      } else if (varType.equals(SymbolTypeBasic.WORD)) {
         RegisterAllocation.RegisterZpWord registerZpWord =
               new RegisterAllocation.RegisterZpWord(currentZp);
         currentZp = currentZp + 2;
         return registerZpWord;
      } else if (varType.equals(SymbolTypeBasic.BOOLEAN)) {
         return new RegisterAllocation.RegisterZpBool(currentZp++);
      } else if (varType.equals(SymbolTypeBasic.VOID)) {
         // No need to setRegister register for VOID value
         return null;
      } else if (varType instanceof SymbolTypePointer) {
         RegisterAllocation.RegisterZpPointerByte registerZpPointerByte =
               new RegisterAllocation.RegisterZpPointerByte(currentZp);
         currentZp = currentZp + 2;
         return registerZpPointerByte;
      } else {
         throw new RuntimeException("Unhandled variable type " + varType);
      }
   }

}
