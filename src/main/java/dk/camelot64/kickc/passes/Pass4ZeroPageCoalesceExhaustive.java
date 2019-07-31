package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.LiveRangeEquivalenceClass;
import dk.camelot64.kickc.model.LiveRangeEquivalenceClassSet;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.values.ScopeRef;

import java.util.Collection;
import java.util.LinkedHashSet;
import java.util.Set;

/**
 * Exhaustive attempt to coalesces zero page registers where live ranges do not overlap.
 * An optional final step done after all other register optimizations and before ASM generation.
 * Performs an exhaustive search - so it can take a lot of time!
 */
public class Pass4ZeroPageCoalesceExhaustive extends Pass2Base {

   public Pass4ZeroPageCoalesceExhaustive(Program program) {
      super(program);
   }

   public void coalesce() {
      LinkedHashSet<String> unknownFragments = new LinkedHashSet<>();
      LiveRangeEquivalenceClassSet liveRangeEquivalenceClassSet = getProgram().getLiveRangeEquivalenceClassSet();
      Collection<ScopeRef> threads = Pass4ZeroPageCoalesce.getThreadHeads(getProgram());
      boolean change;
      do {
         change = coalesce(liveRangeEquivalenceClassSet, threads, unknownFragments);
      } while(change);

      if(unknownFragments.size() > 0) {
         getLog().append("MISSING FRAGMENTS");
         for(String unknownFragment : unknownFragments) {
            getLog().append("  " + unknownFragment);
         }
      }

   }

   /**
    * Find any two equivalence classes that can be coalesced into one - and perform the coalescence.
    *
    * @param liveRangeEquivalenceClassSet The set of live range equivalence classes
    * @param unknownFragments Receives information about any unknown fragments encountered during ASM generation
    * @return true if any classes were coalesced. False otherwise.
    */
   private boolean coalesce(LiveRangeEquivalenceClassSet liveRangeEquivalenceClassSet, Collection<ScopeRef> threadHeads, Set<String> unknownFragments) {
      for(LiveRangeEquivalenceClass thisEquivalenceClass : liveRangeEquivalenceClassSet.getEquivalenceClasses()) {
         for(LiveRangeEquivalenceClass otherEquivalenceClass : liveRangeEquivalenceClassSet.getEquivalenceClasses()) {
            Pass4ZeroPageCoalesce.LiveRangeEquivalenceClassCoalesceCandidate candidate = new Pass4ZeroPageCoalesce.LiveRangeEquivalenceClassCoalesceCandidate(thisEquivalenceClass, otherEquivalenceClass, null);
            boolean modified = Pass4ZeroPageCoalesce.attemptCoalesce(candidate, threadHeads, unknownFragments, getProgram());
            if(modified) {
               return true;
            }
         }
      }
      return false;
   }


}
