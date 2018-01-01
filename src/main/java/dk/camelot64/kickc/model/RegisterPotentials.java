package dk.camelot64.kickc.model;

import java.util.*;

/**
 * Holds potential registers for each live range equivalence class in the program.
 */
public class RegisterPotentials {

   private Map<LiveRangeEquivalenceClass, List<Registers.Register>> potentials;

   public RegisterPotentials() {
      this.potentials = new LinkedHashMap<>();
   }

   public List<Registers.Register> getPotentialRegisters(LiveRangeEquivalenceClass equivalenceClass) {
      return potentials.get(equivalenceClass);
   }

   public void setPotentialRegisters(LiveRangeEquivalenceClass equivalenceClass, List<Registers.Register> registers) {
      potentials.put(equivalenceClass, new ArrayList<>(registers));
   }

   public void removePotentialRegister(LiveRangeEquivalenceClass equivalenceClass, Registers.Register register) {
      List<Registers.Register> registers = potentials.get(equivalenceClass);
      registers.remove(register);
   }

   public RegisterCombinationIterator getAllCombinations(Collection<LiveRangeEquivalenceClass> equivalenceClasses) {
      return new RegisterCombinationIterator(new ArrayList<>(equivalenceClasses), this);
   }

   @Override
   public String toString() {
      StringBuilder out = new StringBuilder();
      for(LiveRangeEquivalenceClass liveRangeEquivalenceClass : potentials.keySet()) {
         out.append("Potential registers ");
         out.append(liveRangeEquivalenceClass.toString());
         out.append(" : ");
         List<Registers.Register> registers = potentials.get(liveRangeEquivalenceClass);
         for(Registers.Register register : registers) {
            out.append(register.toString());
            out.append(" , ");
         }
         out.append("\n");
      }
      return out.toString();
   }

   public void addPotentialRegister(LiveRangeEquivalenceClass equivalenceClass, Registers.Register register) {
      List<Registers.Register> registers = potentials.get(equivalenceClass);
      if(registers == null) {
         registers = new ArrayList<>();
         potentials.put(equivalenceClass, registers);
      }
      if(!registers.contains(register)) {
         registers.add(register);
      }
   }
}
