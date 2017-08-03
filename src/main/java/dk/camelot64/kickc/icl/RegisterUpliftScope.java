package dk.camelot64.kickc.icl;

import com.ibm.icu.text.NumberFormat;

import java.util.*;

/**
 * Register Uplift information for a single scope.
 */
public class RegisterUpliftScope {

   /**
    * The scope.
    */
   private LabelRef scopeRef;

   /**
    * Live Range Equivalence Classes in the scope sorted by total variable register weight.
    */
   private List<LiveRangeEquivalenceClass> equivalenceClasses;

   public RegisterUpliftScope(LabelRef scopeRef) {
      this.scopeRef = scopeRef;
      this.equivalenceClasses = new ArrayList<>();
   }

   public void setEquivalenceClasses(List<LiveRangeEquivalenceClass> equivalenceClasses) {
      this.equivalenceClasses = equivalenceClasses;
   }

   public LabelRef getScopeRef() {
      return scopeRef;
   }

   public Collection<LiveRangeEquivalenceClass> getEquivalenceClasses() {
      return equivalenceClasses;
   }

   public String toString(VariableRegisterWeights weights) {
      StringBuilder out = new StringBuilder();
      out.append("Uplift Scope [" + scopeRef.toString() + "] ");
      for (LiveRangeEquivalenceClass equivalenceClass : equivalenceClasses) {
         if (weights != null) {
            NumberFormat fmt = NumberFormat.getInstance(Locale.ENGLISH);
            fmt.setMaximumFractionDigits(2);
            out.append(fmt.format(weights.getTotalWeight(equivalenceClass)) + ": ");
         }
         out.append(equivalenceClass.toString() + " ");
      }
      return out.toString();
   }

   @Override
   public String toString() {
      return toString(null);
   }

   public Iterator<Combination> geCombinationIterator() {
      return new CombinationIterator(scopeRef, equivalenceClasses);
   }

   /**
    * A combination of register/ZP assignments for the equivalence classes of the scope.
    */
   public static class Combination {

      /**
       * The scope.
       */
      private LabelRef scopeRef;


      /**
       * The registers allocated to each equivalence class.
       */
      private Map<LiveRangeEquivalenceClass, RegisterAllocation.Register> allocation;

      public Combination(LabelRef scopeRef) {
         this.scopeRef = scopeRef;
         this.allocation = new LinkedHashMap<>();
      }

      void setRegister(LiveRangeEquivalenceClass equivalenceClass, RegisterAllocation.Register register) {
         allocation.put(equivalenceClass, register);
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
       * Store the best combination in the equivalence classes.
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

   private static class CombinationIterator implements Iterator<Combination> {

      /**
       * The scope we are creating combinations for.
       */
      private LabelRef scopeRef;


      /**
       * The equivalence classes to create register combinations for.
       */
      private List<LiveRangeEquivalenceClass> equivalenceClasses;

      /**
       * The ID of the next iteration. Combinations are created from the index by using modulo.
       */
      private int nextIterationId;

      public CombinationIterator(LabelRef scopeRef, List<LiveRangeEquivalenceClass> equivalenceClasses) {
         this.scopeRef = scopeRef;
         this.equivalenceClasses = equivalenceClasses;
         this.nextIterationId = 0;
      }


      /**
       * Examine the control flow graph to determine which registers could be usable for
       * optimizing the variables in a specific live range equivalence class.
       *
       * The optimizer will only test combinations with these registers
       *
       * @param equivalenceClass The equivalence class
       * @return The registers to try to optimize the variables of the equivalence class into
       */
      public List<RegisterAllocation.Register> getPotentialRegisters(LiveRangeEquivalenceClass equivalenceClass) {
         // TODO!!

      }



      @Override
      public boolean hasNext() {
         return nextIterationId < getNumIterations();
      }

      private int getNumIterations() {
         int numIterations = 1;
         for (LiveRangeEquivalenceClass equivalenceClass : equivalenceClasses) {
            RegisterAllocation.Register defaultReegister = equivalenceClass.getRegister();
            if (defaultReegister.getType().equals(RegisterAllocation.RegisterType.ZP_BYTE)) {
               numIterations = numIterations *5;

            }
         }
         return numIterations;
      }

      @Override
      public Combination next() {
         Combination combination = new Combination(scopeRef);
         int combinationIdRest = nextIterationId;
         for (LiveRangeEquivalenceClass equivalenceClass : equivalenceClasses) {
            RegisterAllocation.Register defaultReegister = equivalenceClass.getRegister();
            if (defaultReegister.getType().equals(RegisterAllocation.RegisterType.ZP_BYTE)) {
               int registerIdx = (combinationIdRest % 5);
               List<RegisterAllocation.Register> potentialRegisters =
                     Arrays.asList(
                           defaultReegister,
                           RegisterAllocation.getRegisterA(),
                           RegisterAllocation.getRegisterX(),
                           RegisterAllocation.getRegisterY(),
                           RegisterAllocation.getRegisterALU());
               RegisterAllocation.Register register = potentialRegisters.get(registerIdx);
               combination.setRegister(equivalenceClass, register);
               combinationIdRest = (int) Math.floor(combinationIdRest / 5);
            } else {
               combination.setRegister(equivalenceClass, defaultReegister);
            }
         }
         nextIterationId++;
         return combination;
      }

      @Override
      public void remove() {
         throw new RuntimeException("Not supported");
      }
   }
}
