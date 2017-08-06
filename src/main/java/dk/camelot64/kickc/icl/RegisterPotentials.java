package dk.camelot64.kickc.icl;

import java.util.*;

/**
 * Holds potential registers for each live range equivalence class in the program.
 */
public class RegisterPotentials {

   private Map<LiveRangeEquivalenceClass, List<RegisterAllocation.Register>> potentials;

   public RegisterPotentials() {
      this.potentials = new LinkedHashMap<>();
   }

   public List<RegisterAllocation.Register> getPotentialRegisters(LiveRangeEquivalenceClass equivalenceClass) {
      return potentials.get(equivalenceClass);
   }

   public void setPotentialRegisters(LiveRangeEquivalenceClass equivalenceClass, List<RegisterAllocation.Register> registers) {
      potentials.put(equivalenceClass, new ArrayList<>(registers));
   }

   public void removePotentialRegister(LiveRangeEquivalenceClass equivalenceClass, RegisterAllocation.Register register) {
      List<RegisterAllocation.Register> registers = potentials.get(equivalenceClass);
      registers.remove(register);
   }

   public RegisterCombinationIterator getAllCombinations(Collection<LiveRangeEquivalenceClass> equivalenceClasses) {
      return new RegisterCombinationIterator(new ArrayList<>(equivalenceClasses), this);
   }

   @Override
   public String toString() {
      StringBuilder out = new StringBuilder();
      for (LiveRangeEquivalenceClass liveRangeEquivalenceClass : potentials.keySet()) {
         out.append("Potential registers ");
         out.append(liveRangeEquivalenceClass.toString());
         out.append(" : ");
         List<RegisterAllocation.Register> registers = potentials.get(liveRangeEquivalenceClass);
         for (RegisterAllocation.Register register : registers) {
            out.append(register.toString());
            out.append(" , ");
         }
         out.append("\n");
      }
      return out.toString();
   }

   public void addPotentialRegister(LiveRangeEquivalenceClass equivalenceClass, RegisterAllocation.Register register) {
      List<RegisterAllocation.Register> registers = potentials.get(equivalenceClass);
      if (!registers.contains(register)) {
         registers.add(register);
      }
   }
}
