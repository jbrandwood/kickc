package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.CompileLog;
import dk.camelot64.kickc.icl.*;

/**
 * Coalesces zero page registers where their live ranges do not overlap.
 * A final step done after all other register optimizations and before ASM generation.
 */
public class Pass3ZeroPageCoalesce {

   private Program program;
   private CompileLog log;

   public Pass3ZeroPageCoalesce(Program program, CompileLog log) {
      this.program = program;
      this.log = log;
   }

   public void allocate() {
      LiveRangeEquivalenceClassSet liveRangeEquivalenceClassSet = program.getScope().getLiveRangeEquivalenceClassSet();

      boolean change;
      do {
         change = coalesce(liveRangeEquivalenceClassSet);
      } while (change);

   }

   /**
    * Find two equivalence classes that can be coalesced into one - and perform the colalescence.
    *
    * @param liveRangeEquivalenceClassSet The set of live range equivalence classes
    * @return true if any classes were coalesced. False otherwise.
    */
   private boolean coalesce(LiveRangeEquivalenceClassSet liveRangeEquivalenceClassSet) {
      for (LiveRangeEquivalenceClass myEquivalenceClass : liveRangeEquivalenceClassSet.getEquivalenceClasses()) {
         for (LiveRangeEquivalenceClass otherEquivalenceClass : liveRangeEquivalenceClassSet.getEquivalenceClasses()) {
            if (!myEquivalenceClass.equals(otherEquivalenceClass)) {
               if(canCoalesce(myEquivalenceClass, otherEquivalenceClass)) {
                  log.append("Coalescing zero page register [ "+myEquivalenceClass+" ] with [ "+otherEquivalenceClass+" ]" );
                  myEquivalenceClass.addAll(otherEquivalenceClass);
                  liveRangeEquivalenceClassSet.remove(otherEquivalenceClass);
                  return true;
               }
            }
         }
      }
      return false;
   }

   private boolean canCoalesce(LiveRangeEquivalenceClass myEquivalenceClass, LiveRangeEquivalenceClass otherEquivalenceClass) {
      VariableRef myVariableRef = myEquivalenceClass.getVariables().get(0);
      Variable myVariable = program.getScope().getVariable(myVariableRef);
      VariableRef otherVariableRef = otherEquivalenceClass.getVariables().get(0);
      Variable otherVariable = program.getScope().getVariable(otherVariableRef);
      if (myVariable.getType().equals(otherVariable.getType())) {
         // Types match
         if (myEquivalenceClass.getRegister().isZp() && otherEquivalenceClass.getRegister().isZp()) {
            // Both registers are on Zero Page
            if (!myEquivalenceClass.getLiveRange().overlaps(otherEquivalenceClass.getLiveRange())) {
               // Live ranges do not overlap
               // Perform coalesce!
               return true;
            }
         }
      }
      return false;
   }

}
