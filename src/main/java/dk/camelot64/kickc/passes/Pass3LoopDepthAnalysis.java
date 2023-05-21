package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.values.LabelRef;
import dk.camelot64.kickc.model.values.ScopeRef;
import dk.camelot64.kickc.passes.calcs.PassNCalcCallGraph;

import java.util.*;

/**
 * Finds the depth of loops in the control flow graph.
 * Uses the call graph and natural loops of the control flow graph.
 */
public class Pass3LoopDepthAnalysis extends Pass2Base {

   private CallGraph callGraph;
   private NaturalLoopSet loopSet;

   public Pass3LoopDepthAnalysis(Program program) {
      super(program);
      callGraph = getProgram().getCallGraph();
      loopSet = getProgram().getLoopSet();
   }

   /**
    * Finds the depth of loops in the control flow graph.
    * Uses the call graph and natural loops of the control flow graph.
    */
   public void findLoopDepths() {
      Deque<ScopeRef> todo = new ArrayDeque<>();
      Set<ScopeRef> done = new LinkedHashSet<>();

      List<Graph.Block> entryPointBlocks = getProgram().getEntryPointBlocks();
      for(var entryPointBlock : entryPointBlocks)
         todo.push(entryPointBlock.getScope());

      while(!todo.isEmpty()) {
         ScopeRef currentScope = todo.pop();
         done.add(currentScope);
         CallGraph.CallBlock currentCallBlock = callGraph.getOrCreateCallBlock(currentScope);
         // Add called sub blocks for later processing
         Collection<ScopeRef> subBlocks = currentCallBlock.getCalledBlocks();
         for(ScopeRef subBlock : subBlocks) {
            if(!done.contains(subBlock) && !todo.contains(subBlock)) {
               todo.add(subBlock);
            }
         }
         // Find the scope blocks calling the current scope block - and the loop depth of the blocks where the call statement is
         int callingDepth = getCallingDepth(currentScope, new ArrayList<>());
         findLoopDepth(currentScope, callingDepth);
      }
   }

   private int getCallingDepth(ScopeRef currentScope, List<ScopeRef> path) {
      // Avoid infinite recursion
      if(path.contains(currentScope))
         return 10;
      path = new ArrayList<>(path);
      path.add(currentScope);

      int callingDepth = 1;
      Collection<ScopeRef> callingScopes = callGraph.getCallingBlocks(currentScope);
      for(ScopeRef callingScope : callingScopes) {
         CallGraph.CallBlock callingBlock = callGraph.getCallBlock(callingScope);
         Collection<CallGraph.CallBlock.Call> calls = callingBlock.getCalls(currentScope);
         for(CallGraph.CallBlock.Call call : calls) {
            // First look for loops containing the call
            int callStatementIdx = call.getCallStatementIdx();
            Graph.Block callingControlBlock = getProgram().getStatementInfos().getBlock(callStatementIdx);
            Collection<NaturalLoop> callingLoops = loopSet.getLoopsContainingBlock(callingControlBlock.getLabel());
            for(NaturalLoop callingLoop : callingLoops) {
               Integer depth = callingLoop.getDepth();
               if(depth != null) {
                  int potentialDepth = depth + 1;
                  if(potentialDepth > callingDepth) {
                     callingDepth = potentialDepth;
                  }
               } else {
                  getLog().append("null depth in calling loop " + callingLoop.toString() + " in scope " + currentScope);
               }
            }
            // Also look through all callers
            int superCallingDepth = getCallingDepth(callingScope, path);
            if(superCallingDepth > callingDepth) {
               callingDepth = superCallingDepth;
            }
         }
      }
      return callingDepth;
   }

   private void findLoopDepth(ScopeRef currentScope, int initialDepth) {
      NaturalLoopSet loopSet = getProgram().getLoopSet();
      // Find loops in the current scope block
      List<NaturalLoop> currentScopeLoops = new ArrayList<>();
      for(NaturalLoop loop : loopSet.getLoops()) {
         LabelRef loopHead = loop.getHead();
         Graph.Block loopHeadBlock = getGraph().getBlock(loopHead);
         ScopeRef scopeRef = PassNCalcCallGraph.getScopeRef(loopHeadBlock, getProgram());
         if(scopeRef.equals(currentScope)) {
            // Loop is inside current scope block!
            currentScopeLoops.add(loop);
         }
      }

      if(getLog().isVerboseLoopAnalysis()) {
         getLog().append("Found " + currentScopeLoops.size() + " loops in scope [" + currentScope.toString() + "]");
         for(NaturalLoop loop : currentScopeLoops) {
            getLog().append("  " + loop.toString());
         }
      }

      // Find loop nesting depths in current scope loops
      Set<NaturalLoop> done = new LinkedHashSet<>();
      Deque<NaturalLoop> todo = new ArrayDeque<>(currentScopeLoops);
      while(!todo.isEmpty()) {
         NaturalLoop loop = todo.getFirst();
         todo.removeFirst();
         // Does any unprocessed loop nest this one?
         boolean postpone = false;
         for(NaturalLoop otherLoop : todo) {
            if(otherLoop.nests(loop)) {
               // postpone this loop and move on
               postpone = true;
               break;
            }
         }
         if(postpone) {
            todo.addLast(loop);
            continue;
         }
         int depth = initialDepth;
         // Does any already processed loop nest this one?
         for(NaturalLoop otherLoop : done) {
            if(otherLoop.nests(loop)) {
               int potentialDepth = otherLoop.getDepth() + 1;
               if(potentialDepth > depth) {
                  depth = potentialDepth;
               }
            }
         }
         loop.setDepth(depth);
         done.add(loop);
      }
   }


}
