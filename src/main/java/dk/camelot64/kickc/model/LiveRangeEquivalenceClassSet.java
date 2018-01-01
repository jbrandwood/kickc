package dk.camelot64.kickc.model;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * A set of live range equivalence classes.
 */
public class LiveRangeEquivalenceClassSet {

   /**
    * Maps variables to their containing class.
    */
   Map<VariableRef, LiveRangeEquivalenceClass> varClass;
   /**
    * The containing program.
    */
   private Program program;
   /**
    * The equivalence classes of the set.
    */
   private List<LiveRangeEquivalenceClass> equivalenceClasses;

   public LiveRangeEquivalenceClassSet(Program program) {
      this.program = program;
      this.equivalenceClasses = new ArrayList<>();
      this.varClass = new LinkedHashMap<>();
   }

   /**
    * Get the containing program
    *
    * @return The program
    */
   Program getProgram() {
      return program;
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
      if(equivalenceClass != null) {
         return equivalenceClass;
      }
      // Not found - create it
      equivalenceClass = new LiveRangeEquivalenceClass(this);
      equivalenceClasses.add(equivalenceClass);
      equivalenceClass.addVariable(variable);
      return equivalenceClass;
   }

   /**
    * Consolidates two live range equivalence calsses into one.
    * All variables and live ranges from the other class is added to the first one - and the other one is deleted.
    *
    * @param equivalenceClass The first live range equivalence class.
    * @param otherEquivalenceClass The other live range equivalence class, that is added to the first and deleted.
    */
   public void consolidate(LiveRangeEquivalenceClass equivalenceClass, LiveRangeEquivalenceClass otherEquivalenceClass) {
      equivalenceClass.addAll(otherEquivalenceClass);
      equivalenceClasses.remove(otherEquivalenceClass);
   }

   /**
    * Informs the set that class of a variable has ben set - called by add/remove methods inside LiveRangeEquivalenceClass
    *
    * @param variable The variable
    * @param equivalenceClass The class
    */
   void setVarClass(VariableRef variable, LiveRangeEquivalenceClass equivalenceClass) {
      varClass.put(variable, equivalenceClass);
   }

   /**
    * Get the phi equivalence class for a specific variable.
    *
    * @param variable The variable
    * @return The existing phi equivalence class. null if no equivalence class contains the variable.
    */
   public LiveRangeEquivalenceClass getEquivalenceClass(VariableRef variable) {
      return varClass.get(variable);
   }

   public List<LiveRangeEquivalenceClass> getEquivalenceClasses() {
      return equivalenceClasses;
   }

   public int size() {
      return equivalenceClasses.size();
   }

   /**
    * Store the register allocation of the live range equivalence classes into the variables in the symbol table (program scope).
    */
   public void storeRegisterAllocation() {
      for(LiveRangeEquivalenceClass equivalenceClass : getEquivalenceClasses()) {
         Registers.Register register = equivalenceClass.getRegister();
         for(VariableRef variable : equivalenceClass.getVariables()) {
            Variable var = program.getSymbolInfos().getVariable(variable);
            var.setAllocation(register);
         }
      }
   }

}
