package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.values.ProcedureRef;
import dk.camelot64.kickc.model.values.ScopeRef;
import dk.camelot64.kickc.model.values.SymbolRef;
import dk.camelot64.kickc.model.values.VariableRef;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Set;

/**
 * Coalesces memory registers where their live ranges do not overlap.
 * A final step done after all other register optimizations and before ASM generation.
 */
public abstract class Pass4MemoryCoalesce extends Pass2Base {

   public Pass4MemoryCoalesce(Program program) {
      super(program);
   }

   /**
    * Get all functions that represents a separate thread in the program.
    * Each interrupt function and the main() function are threads.
    *
    * @return The threads.
    */
   public static Collection<ScopeRef> getThreadHeads(Program program) {
      ArrayList<ScopeRef> threadHeads = new ArrayList<>();
      Collection<Procedure> procedures = program.getScope().getAllProcedures(true);
      for(Procedure procedure : procedures) {
         if(procedure.getFullName().equals(SymbolRef.MAIN_PROC_NAME)) {
            threadHeads.add(procedure.getRef());
            continue;
         }
         if(Pass2ConstantIdentification.isAddressOfUsed(procedure.getRef(), program)) {
            threadHeads.add(procedure.getRef());
         }
      }
      return threadHeads;
   }


   /**
    * Determines if two live range equivalence classes can be coalesced.
    *
    * @param ec1 One equivalence class
    * @param ec2 Another equivalence class
    * @param unknownFragments Receives information about any unknown fragments encountered during ASM generation
    * @param program The program
    * @return True if the two equivalence classes can be coalesced into one without problems.
    */
   static boolean canCoalesce(LiveRangeEquivalenceClass ec1, LiveRangeEquivalenceClass ec2, Collection<ScopeRef> threadHeads, Set<String> unknownFragments, Program program) {
      return
            canCoalesceNotEqual(ec1, ec2) &&
                  canCoalesceCompatible(ec1, ec2, program) &&
                  canCoalesceVolatile(ec1, ec2, program) &&
                  canCoalesceThreads(ec1, ec2, threadHeads, program) &&
                  canCoalesceClobber(ec1, ec2, unknownFragments, program);
   }

   /**
    * Determines if two live range equivalence classes are candidates for coalescing by checking that they are not the same
    *
    * @param ec1 One equivalence class
    * @param ec2 Another equivalence class
    * @return True if the two equivalence classes can be coalesced into one without problems.
    */
   private static boolean canCoalesceNotEqual(LiveRangeEquivalenceClass ec1, LiveRangeEquivalenceClass ec2) {
      return !ec1.equals(ec2);
   }

   /**
    * Determines if two live range equivalence classes can be coalesced without cross-thread clobber.
    * This is possible if they are both only called from the same thread head.
    *
    * @param ec1 One equivalence class
    * @param ec2 Another equivalence class
    * @param threadHeads The heads (in the call graph) from each thread in the program
    * @param program The program
    * @return True if the two equivalence classes can be coalesced into one without problems.
    */
   private static boolean canCoalesceThreads(LiveRangeEquivalenceClass ec1, LiveRangeEquivalenceClass ec2, Collection<ScopeRef> threadHeads, Program program) {
      if(threadHeads.size() <= 1) {
         return true;
      }
      CallGraph callGraph = program.getCallGraph();
      Collection<ScopeRef> threads1 = getEquivalenceClassThreads(ec1, program, threadHeads, callGraph);
      Collection<ScopeRef> threads2 = getEquivalenceClassThreads(ec2, program, threadHeads, callGraph);
      if(threads1.isEmpty() || threads2.isEmpty()) {
         return true;
      }
      return threads1.equals(threads2);
   }

   /**
    * Find the threads for the variables in an equivalence class.
    *
    * @param equivalenceClass The equivalence class
    * @param program The program
    * @param threadHeads The threads (heads)
    * @param callGraph The call graph
    * @return All threads containing variables in the equivalence class.
    */
   private static Collection<ScopeRef> getEquivalenceClassThreads(LiveRangeEquivalenceClass equivalenceClass, Program program, Collection<ScopeRef> threadHeads, CallGraph callGraph) {
      Collection<ScopeRef> threads = new ArrayList<>();
      for(VariableRef varRef : equivalenceClass.getVariables()) {
         Variable variable = program.getScope().getVariable(varRef);
         ScopeRef scopeRef = variable.getScope().getRef();
         if(scopeRef.equals(ScopeRef.ROOT)) {
            ProcedureRef mainThreadHead = program.getScope().getProcedure(SymbolRef.MAIN_PROC_NAME).getRef();
            if(!threads.contains(mainThreadHead)) {
               threads.add(mainThreadHead);
            }
         } else {
            Collection<ScopeRef> recursiveCallers = callGraph.getRecursiveCallers(scopeRef);
            for(ScopeRef threadHead : threadHeads) {
               if(recursiveCallers.contains(threadHead)) {
                  if(!threads.contains(threadHead)) {
                     threads.add(threadHead);
                  }
               }
            }
         }
      }
      return threads;
   }

   /**
    * Determines if two live range equivalence classes have compatible registers.
    * The registers are compatible if they are in memory and have the same type and size.
    *
    * @param ec1 One equivalence class
    * @param ec2 Another equivalence class
    * @param program The program
    * @return True if the two equivalence classes can be coalesced into one without problems.
    */
   private static boolean canCoalesceCompatible(LiveRangeEquivalenceClass ec1, LiveRangeEquivalenceClass ec2, Program program) {
      Registers.Register register1 = ec1.getRegister();
      Registers.Register register2 = ec2.getRegister();
      // Check the both registers are in memory
      if(!register1.isMem() || !register2.isMem())
         return false;
      // Check the both registers have the same type
      if(!register1.getType().equals(register2.getType()))
         return false;
      // Check the both registers have the same size
      if(register1.getBytes() != register2.getBytes())
         return false;
      return true;
   }

   /**
    * Determines if two live range equivalence classes can be coalesced without clobber.
    * This is possible if they are both allocated to zero page, have the same size and the resulting ASM has no live range overlaps or clobber issues.
    *
    * @param ec1 One equivalence class
    * @param ec2 Another equivalence class
    * @param unknownFragments Receives information about any unknown fragments encountered during ASM generation
    * @param program The program
    * @return True if the two equivalence classes can be coalesced into one without problems.
    */
   private static boolean canCoalesceClobber(LiveRangeEquivalenceClass ec1, LiveRangeEquivalenceClass ec2, Set<String> unknownFragments, Program program) {
      Registers.Register register1 = ec1.getRegister();
      // Try out the coalesce to test if it works
      RegisterCombination combination = new RegisterCombination();
      combination.setRegister(ec2, register1);
      return Pass4RegisterUpliftCombinations.generateCombinationAsm(combination, program, unknownFragments, ScopeRef.ROOT);
   }

   /**
    * Determines if any volatile variables prevents coalescing two equivalence classes
    *
    * @param ec1 One equivalence class
    * @param ec2 Another equivalence class
    * @param program The program
    * @return True if the two equivalence classes can be coalesced into one without problems with volatility.
    */
   private static boolean canCoalesceVolatile(LiveRangeEquivalenceClass ec1, LiveRangeEquivalenceClass ec2, Program program) {
      // If any variable inside is volatile only allow coalesceing with itself
      if(ec1.hasVolatile(program) || ec2.hasVolatile(program)) {
         Variable baseVar1 = ec1.getSingleVariableBase(program);
         Variable baseVar2 = ec2.getSingleVariableBase(program);
         if(baseVar1 == null || baseVar2 == null) {
            // One of the equivalence classes have different base variables inside
            return false;
         }
         if(!baseVar1.equals(baseVar2)) {
            // The two equivalence classes have different base variables
            return false;
         }
      }
      return true;
   }


   /**
    * Try to coalesce two live range equivalence classes
    *
    * @param candidate The candidate for coalescing
    * @param threadHeads The thread heads (get using {@link #getThreadHeads(Program)})
    * @param unknownFragments Receives information about ASM fragments that can't be created during the coalescence).
    * @param program The program.
    * @return true if the coalescence succeeds and the program was updated. false otherwise.
    */
   public static boolean attemptCoalesce(LiveRangeEquivalenceClassCoalesceCandidate candidate, Collection<ScopeRef> threadHeads, Set<String> unknownFragments, Program program) {
      LiveRangeEquivalenceClassSet liveRangeEquivalenceClassSet = program.getLiveRangeEquivalenceClassSet();
      List<LiveRangeEquivalenceClass> equivalenceClasses = liveRangeEquivalenceClassSet.getEquivalenceClasses();
      if(equivalenceClasses.contains(candidate.getEc1()) && equivalenceClasses.contains(candidate.getEc2())) {
         // Both equivalence classes still exist
         if(Pass4MemoryCoalesce.canCoalesce(candidate.getEc1(), candidate.getEc2(), threadHeads, unknownFragments, program)) {
            String scoreString = (candidate.getScore() == null) ? "" : (" - score: " + candidate.getScore());
            program.getLog().append("Coalescing zero page register [ " + candidate.getEc1() + " ] with [ " + candidate.getEc2() + " ]" + scoreString);
            liveRangeEquivalenceClassSet.consolidate(candidate.getEc1(), candidate.getEc2());
            // Reset the program register allocation
            program.getLiveRangeEquivalenceClassSet().storeRegisterAllocation();
            return true;
         }
      }
      return false;
   }


   /**
    * A pair of live range equivalence classes that are candidates for coalescing.
    * The pair is unordered - meaning it is equal to the pair with the same classes in opposite order.
    */
   static class LiveRangeEquivalenceClassCoalesceCandidate {
      private LiveRangeEquivalenceClass ec1;
      private LiveRangeEquivalenceClass ec2;
      private Integer score;

      public LiveRangeEquivalenceClassCoalesceCandidate(LiveRangeEquivalenceClass ec1, LiveRangeEquivalenceClass ec2, Integer score) {
         this.ec1 = ec1;
         this.ec2 = ec2;
         this.score = score;
      }

      @Override
      public boolean equals(Object o) {
         if(this == o) return true;
         if(o == null || getClass() != o.getClass()) return false;
         LiveRangeEquivalenceClassCoalesceCandidate that = (LiveRangeEquivalenceClassCoalesceCandidate) o;
         if(ec1.equals(that.ec1) && ec2.equals(that.ec2)) return true;
         if(ec1.equals(that.ec2) && ec2.equals(that.ec1)) return true;
         return false;
      }

      @Override
      public int hashCode() {
         return ec1.hashCode() + ec2.hashCode();
      }

      public Integer getScore() {
         return score;
      }

      public LiveRangeEquivalenceClass getEc1() {
         return ec1;
      }

      public LiveRangeEquivalenceClass getEc2() {
         return ec2;
      }
   }
}
