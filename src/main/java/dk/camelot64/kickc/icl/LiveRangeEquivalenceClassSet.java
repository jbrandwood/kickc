package dk.camelot64.kickc.icl;

import java.util.ArrayList;
import java.util.List;

/** A set of live range equivalence classes. */
public class LiveRangeEquivalenceClassSet {

   private Program program;

   private List<LiveRangeEquivalenceClass> equivalenceClasses;

   public LiveRangeEquivalenceClassSet(Program program) {
      this.program = program;
      this.equivalenceClasses = new ArrayList<>();
   }

   /**
    * Get the phi equivalence class for a specific variable.
    * If the equivalence class does not exist it is created.
    *
    * @param variable The variable
    * @return The existing or new phi equivalence class
    */
   public LiveRangeEquivalenceClass getOrCreateEquivalenceClass(VariableRef variable) {
      LiveRangeEquivalenceClass equivalenceClass = getEquivalenceClass(variable);
      if (equivalenceClass != null) {
         return equivalenceClass;
      }
      // Not found - create it
      equivalenceClass = new LiveRangeEquivalenceClass(program);
      equivalenceClasses.add(equivalenceClass);
      equivalenceClass.addVariable(variable);
      return equivalenceClass;
   }

   /**
    * Get the phi equivalence class for a specific variable.
    *
    * @param variable The variable
    * @return The existing phi equivalence class. null if no equivalence class contains the variable.
    */
   public LiveRangeEquivalenceClass getEquivalenceClass(VariableRef variable) {
      for (LiveRangeEquivalenceClass equivalenceClass : equivalenceClasses) {
         if (equivalenceClass.contains(variable)) {
            return equivalenceClass;
         }
      }
      return null;
   }

   public List<LiveRangeEquivalenceClass> getEquivalenceClasses() {
      return equivalenceClasses;
   }

   public int size() {
      return equivalenceClasses.size();
   }

   public void remove(LiveRangeEquivalenceClass equivalenceClass) {
      equivalenceClasses.remove(equivalenceClass);
   }

   /**
    * Store the register allocation of the live range equivalence classes into the variables in the symbol table (program scope).
    */
   public void storeRegisterAllocation() {
      for (LiveRangeEquivalenceClass equivalenceClass : getEquivalenceClasses()) {
         Registers.Register register = equivalenceClass.getRegister();
         for (VariableRef variable : equivalenceClass.getVariables()) {
            Variable var = program.getScope().getVariable(variable);
            var.setAllocation(register);
         }
      }
   }


}
