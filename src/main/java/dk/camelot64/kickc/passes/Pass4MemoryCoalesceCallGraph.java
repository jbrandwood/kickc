package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.values.ProcedureRef;
import dk.camelot64.kickc.model.values.ScopeRef;
import dk.camelot64.kickc.model.values.VariableRef;

import java.util.*;

/**
 * Use the call graph to coalesce memory registers.
 * For each live range equivalence class:
 * - Look up through the call graph and avoid all variables declared in the scopes there
 * - Go through already handled live range equivalence classes and if any exist with no scope overlap with the call graph - try to coalesce
 * - Add to the list of already handled live range equivalence classes
 */
public class Pass4MemoryCoalesceCallGraph extends Pass2Base {

   public Pass4MemoryCoalesceCallGraph(Program program) {
      super(program);
   }

   public void coalesce() {
      LinkedHashSet<String> unknownFragments = new LinkedHashSet<>();
      LiveRangeEquivalenceClassSet liveRangeEquivalenceClassSet = getProgram().getLiveRangeEquivalenceClassSet();
      Collection<ScopeRef> threads = Pass4MemoryCoalesce.getThreadHeads(getProgram());
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
         // Skip main-memory registers
         if(Registers.RegisterType.MAIN_MEM.equals(thisEC.getRegister().getType()))
            continue;
         // Find all calling scopes - since we want to avoid coalescing with variables in these
         Set<ScopeRef> allCallingScopes = new LinkedHashSet<>();
         for(ScopeRef ecScope : getEquivalenceClassScopes(thisEC)) {
            allCallingScopes.addAll(callGraph.getRecursiveCallerProcs(ecScope));
         }
         // Go through the already handled equivalence classes - and try to coalesce with any that does not have variables from the calling scopes
         boolean coalesced = false;
         for(LiveRangeEquivalenceClass otherEC : handledECs) {
            // Skip main-memory registers
            if(Registers.RegisterType.MAIN_MEM.equals(otherEC.getRegister().getType()))
               continue;
            // Skip if there is a scope overlap
            if(isProcedureOverlap(otherEC, allCallingScopes))
               continue;
            // No scope overlap - attempt to coalesce
            Pass4MemoryCoalesce.LiveRangeEquivalenceClassCoalesceCandidate candidate = new Pass4MemoryCoalesce.LiveRangeEquivalenceClassCoalesceCandidate(thisEC, otherEC, null);
            if(Pass4MemoryCoalesce.attemptCoalesce(candidate, threadHeads, unknownFragments, getProgram())) {
               // Succesfully coalesced with already handled EC - move on to the next one!
               coalesced = true;
               modified = true;
               break;
            }
         }
         if(!coalesced) {
            // Add the already handled
            handledECs.add(thisEC);
         }
      }
      return modified;
   }

   /**
    * Determine if any variable in a live range equivalence class has a scope from the passed set of procedures.
    * @param equivalenceClass The live range equivalence class
    * @param procedureRefs The set of procedures
    * @return true if there is a scope overlap
    */
   private boolean isProcedureOverlap(LiveRangeEquivalenceClass equivalenceClass, Collection<ScopeRef> procedureRefs) {
      boolean scopeOverlap = false;
      for(VariableRef otherVarRef : equivalenceClass.getVariables()) {
         ScopeRef otherProcedureRef = getScopeRef(otherVarRef);
         if(procedureRefs.contains(otherProcedureRef))
            scopeOverlap = true;
      }
      return scopeOverlap;
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
         ScopeRef scopeRef = getScopeRef(varRef);
         if(!ecScopes.contains(scopeRef))
            ecScopes.add(scopeRef);
      }
      return ecScopes;
   }

   private static ScopeRef getScopeRef(VariableRef varRef) {
      ScopeRef scopeRef = new ScopeRef(varRef.getScopeNames());
      if(!ScopeRef.ROOT.equals(scopeRef)) {
         scopeRef = new ProcedureRef(varRef.getScopeNames());
      }
      return scopeRef;
   }


}
