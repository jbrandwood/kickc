package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.symbols.VariableUnversioned;
import dk.camelot64.kickc.model.values.ScopeRef;

import java.util.LinkedHashSet;
import java.util.Set;

/**
 * Coalesces zero page registers where their live ranges do not overlap.
 * A final step done after all other register optimizations and before ASM generation.
 */
public class Pass4ZeroPageCoalesce extends Pass2Base {

   public Pass4ZeroPageCoalesce(Program program) {
      super(program);
   }

   public void coalesce() {
      LinkedHashSet<String> unknownFragments = new LinkedHashSet<>();
      LiveRangeEquivalenceClassSet liveRangeEquivalenceClassSet = getProgram().getLiveRangeEquivalenceClassSet();
      boolean change;
      do {
         change = coalesce(liveRangeEquivalenceClassSet, unknownFragments);
      } while(change);

      if(unknownFragments.size() > 0) {
         getLog().append("MISSING FRAGMENTS");
         for(String unknownFragment : unknownFragments) {
            getLog().append("  " + unknownFragment);
         }
      }

   }

   /**
    * Find two equivalence classes that can be coalesced into one - and perform the coalescence.
    *
    * @param liveRangeEquivalenceClassSet The set of live range equivalence classes
    * @param unknownFragments Receives information about any unknown fragments encountered during ASM generation
    * @return true if any classes were coalesced. False otherwise.
    */
   private boolean coalesce(LiveRangeEquivalenceClassSet liveRangeEquivalenceClassSet, Set<String> unknownFragments) {
      for(LiveRangeEquivalenceClass thisEquivalenceClass : liveRangeEquivalenceClassSet.getEquivalenceClasses()) {
         for(LiveRangeEquivalenceClass otherEquivalenceClass : liveRangeEquivalenceClassSet.getEquivalenceClasses()) {
            if(!thisEquivalenceClass.equals(otherEquivalenceClass)) {
               if(canCoalesce(thisEquivalenceClass, otherEquivalenceClass, unknownFragments, getProgram())) {
                  getLog().append("Coalescing zero page register [ " + thisEquivalenceClass + " ] with [ " + otherEquivalenceClass + " ]");
                  liveRangeEquivalenceClassSet.consolidate(thisEquivalenceClass, otherEquivalenceClass);
                  // Reset the program register allocation
                  getProgram().getLiveRangeEquivalenceClassSet().storeRegisterAllocation();
                  return true;
               }
            }
         }
      }
      return false;
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
   public static boolean canCoalesce(LiveRangeEquivalenceClass ec1, LiveRangeEquivalenceClass ec2, Set<String> unknownFragments, Program program) {
      return canCoalesceVolatile(ec1, ec2, program) && canCoalesceClobber(ec1, ec2, unknownFragments, program);
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
      Registers.Register register2 = ec2.getRegister();
      if(register1.isZp() && register2.isZp() && register1.getType().equals(register2.getType())) {
         // Both registers are on Zero Page & have the same zero page size
         // Try out the coalesce to test if it works
         RegisterCombination combination = new RegisterCombination();
         combination.setRegister(ec2, register1);
         return Pass4RegisterUpliftCombinations.generateCombinationAsm(combination, program, unknownFragments, ScopeRef.ROOT);
      }
      return false;
   }

   /**
    * Determines if any volatile varialbes prevents coalescing two equivalence classes
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
         if(baseVar1==null || baseVar2==null) {
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

}
