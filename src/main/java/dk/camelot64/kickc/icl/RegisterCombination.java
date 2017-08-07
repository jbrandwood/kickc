package dk.camelot64.kickc.icl;

import java.util.LinkedHashMap;
import java.util.Map;

/** A combination of register/ZP assignments for a set of equivalence classes  */
public class RegisterCombination {

   /**
    * The registers allocated to each equivalence class.
    */
   private Map<LiveRangeEquivalenceClass, RegisterAllocation.Register> allocation;

   public RegisterCombination() {
      this.allocation = new LinkedHashMap<>();
   }

   void setRegister(LiveRangeEquivalenceClass equivalenceClass, RegisterAllocation.Register register) {
      allocation.put(equivalenceClass, register);
   }

   public RegisterAllocation.Register getRegister(LiveRangeEquivalenceClass equivalenceClass) {
      return allocation.get(equivalenceClass);
   }

   /**
    * Allocate the registers of the combination into the programs register allocation
    */
   public void allocate(RegisterAllocation registerAllocation) {
      for (LiveRangeEquivalenceClass equivalenceClass : allocation.keySet()) {
         RegisterAllocation.Register register = allocation.get(equivalenceClass);
         for (VariableRef variable : equivalenceClass.getVariables()) {
            registerAllocation.setRegister(variable, register);
         }
      }
   }

   /**
    * Store the combination in the equivalence classes.
    */
   public void store(LiveRangeEquivalenceClassSet equivalenceClassSet) {
      for (LiveRangeEquivalenceClass equivalenceClass : allocation.keySet()) {
         VariableRef variable = equivalenceClass.getVariables().get(0);
         LiveRangeEquivalenceClass globalEquivalenceClass = equivalenceClassSet.getEquivalenceClass(variable);
         RegisterAllocation.Register register = allocation.get(equivalenceClass);
         globalEquivalenceClass.setRegister(register);
      }
   }

   @Override
   public String toString() {
      StringBuilder out = new StringBuilder();
      for (LiveRangeEquivalenceClass equivalenceClass : allocation.keySet()) {
         RegisterAllocation.Register register = allocation.get(equivalenceClass);
         out.append(register.toString()).append(" ").append(equivalenceClass.toString(false)).append(" ");
      }
      return out.toString();
   }
}
