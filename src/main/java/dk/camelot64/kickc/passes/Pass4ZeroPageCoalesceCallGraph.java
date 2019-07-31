package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CallGraph;
import dk.camelot64.kickc.model.LiveRangeEquivalenceClass;
import dk.camelot64.kickc.model.LiveRangeEquivalenceClassSet;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.values.ScopeRef;
import dk.camelot64.kickc.model.values.VariableRef;

import java.util.*;

/**
 * Use the call graph to coalesce zero page registers.
 * For all variables:
 *  - Look up through the call graph and avoid all variables declared in the scopes there
 *  - Go through the zero pages from low to high and try to coalesce with the lowest possible one.
 *
 */
public class Pass4ZeroPageCoalesceCallGraph extends Pass2Base {

   public Pass4ZeroPageCoalesceCallGraph(Program program) {
      super(program);
   }

   public void coalesce() {
      LinkedHashSet<String> unknownFragments = new LinkedHashSet<>();
      LiveRangeEquivalenceClassSet liveRangeEquivalenceClassSet = getProgram().getLiveRangeEquivalenceClassSet();
      Collection<ScopeRef> threads = Pass4ZeroPageCoalesce.getThreadHeads(getProgram());
      boolean modified;
      do {
         modified = coalesce(liveRangeEquivalenceClassSet, threads, unknownFragments);
      } while(modified);

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
      boolean modified = false;
      CallGraph callGraph = getProgram().getCallGraph();
      // All live range equivalence classes already handled - we handle each only once
      List<LiveRangeEquivalenceClass> handledECs = new ArrayList<>();
      List<LiveRangeEquivalenceClass> allECs = new ArrayList<>(liveRangeEquivalenceClassSet.getEquivalenceClasses());
      for(LiveRangeEquivalenceClass thisEC : allECs) {
         // Find all calling scopes - since we want to avoid coalescing with variables in these
         Set<ScopeRef> allCallingScopes = new LinkedHashSet<>();
         for(ScopeRef ecScope : getEquivalenceClassScopes(thisEC)) {
            allCallingScopes.addAll(getAllCallingScopes(ecScope, callGraph));
         }
         // Go through the already handled equivalence classes - and try to coalesce with any that does not have variables from the calling scopes
         boolean coalesced = false;
         for(LiveRangeEquivalenceClass otherEC : handledECs) {
            // Skip if there is a scope overlap
            if(isScopeOverlap(otherEC, allCallingScopes))
               continue;
            // No scope overlap - attempt to coalesce
            Pass4ZeroPageCoalesce.LiveRangeEquivalenceClassCoalesceCandidate candidate = new Pass4ZeroPageCoalesce.LiveRangeEquivalenceClassCoalesceCandidate(thisEC, otherEC, null);
            if(Pass4ZeroPageCoalesce.attemptCoalesce(candidate, threadHeads, unknownFragments, getProgram())) {
               // Succesfully coalesced with already handled EC - move on to the next one!
               coalesced = true;
               modified = true;
               break;
            }
         }
         if(!coalesced) {
            // Add th already handled
            handledECs.add(thisEC);
         }
      }
      return modified;
   }

   /**
    * Determine if any variable in a live range equivalence class has a scope from the passed set of scopes.
    * @param equivalenceClass The live range equivalence class
    * @param scopeRefSet The set of scopes
    * @return true if there is a scope overlap
    */
   private boolean isScopeOverlap(LiveRangeEquivalenceClass equivalenceClass, Collection<ScopeRef> scopeRefSet) {
      boolean scopeOverlap = false;
      for(VariableRef otherVarRef : equivalenceClass.getVariables()) {
         ScopeRef otherScopeRef = new ScopeRef(otherVarRef.getScopeNames());
         if(scopeRefSet.contains(otherScopeRef))
            scopeOverlap = true;
      }
      return scopeOverlap;
   }

   /**
    * Get all scopes call into a specific scope. Recursively includes callers of callers. Also includes the scope itself.
    * @param scopeRef The scope to examine
    * @param callGraph The call graph
    * @return All scopes that call into this one (potentially )
    */
   private Set<ScopeRef> getAllCallingScopes(ScopeRef scopeRef, CallGraph callGraph) {
      LinkedHashSet<ScopeRef> allCallers = new LinkedHashSet<>();
      // Add the scope itself
      allCallers.add(scopeRef);
      // Recursively add the scopes of all callers
      for(CallGraph.CallBlock.Call caller : callGraph.getCallers(scopeRef)) {
         if(!allCallers.contains(caller.getProcedure()))
            allCallers.addAll(getAllCallingScopes(caller.getProcedure(), callGraph));
      }
      return allCallers;
   }

   /**
    * Get all scopes of the variables in a live range equivalence class
    * @param equivalenceClass The live range equivalence class
    * @return All scopes
    */
   private static Collection<ScopeRef> getEquivalenceClassScopes(LiveRangeEquivalenceClass equivalenceClass) {
      List<ScopeRef> ecScopes = new ArrayList<>();
      List<VariableRef> variables = equivalenceClass.getVariables();
      for(VariableRef varRef : variables) {
         ScopeRef scopeRef = new ScopeRef(varRef.getScopeNames());
         if(!ecScopes.contains(scopeRef))
               ecScopes.add(scopeRef);
      }
      return ecScopes;
   }


}
