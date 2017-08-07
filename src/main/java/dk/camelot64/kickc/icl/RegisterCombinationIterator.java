package dk.camelot64.kickc.icl;

import java.util.Iterator;
import java.util.List;

/** Iterator for running through all possible combinations of register allocations for a set of live range equivalence classes */
public class RegisterCombinationIterator implements Iterator<RegisterCombination> {

   /** The equivalence classes to create register combinations for. */
   private List<LiveRangeEquivalenceClass> equivalenceClasses;

   /** The potential registers usable for the equivalence classes. */
   private RegisterPotentials registerPotentials;

   /**
    * The ID of the next iteration. Combinations are created from the index by using modulo.
    */
   private int nextIterationId;

   public RegisterCombinationIterator(List<LiveRangeEquivalenceClass> equivalenceClasses, RegisterPotentials registerPotentials) {
      this.equivalenceClasses = equivalenceClasses;
      this.registerPotentials = registerPotentials;
      this.nextIterationId = 0;
   }

   @Override
   public boolean hasNext() {
      return nextIterationId < getNumIterations();
   }

   public int getNumIterations() {
      int numIterations = 1;
      for (LiveRangeEquivalenceClass equivalenceClass : equivalenceClasses) {
         List<RegisterAllocation.Register> registers = registerPotentials.getPotentialRegisters(equivalenceClass);
         numIterations = numIterations * registers.size();
      }
      return numIterations;
   }

   @Override
   public RegisterCombination next() {
      RegisterCombination combination = new RegisterCombination();
      int combinationIdRest = nextIterationId;
      for (LiveRangeEquivalenceClass equivalenceClass : equivalenceClasses) {
         List<RegisterAllocation.Register> potentials = registerPotentials.getPotentialRegisters(equivalenceClass);
         int registerIdx = (combinationIdRest % potentials.size());
         RegisterAllocation.Register register = potentials.get(registerIdx);
         combination.setRegister(equivalenceClass, register);
         combinationIdRest = (int) Math.floor(combinationIdRest / potentials.size());
      }
      nextIterationId++;
      return combination;
   }

   @Override
   public void remove() {
      throw new RuntimeException("Not supported");
   }
}
