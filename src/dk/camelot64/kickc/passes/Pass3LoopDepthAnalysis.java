package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.CompileLog;
import dk.camelot64.kickc.icl.*;

import java.util.*;

/**
 * Finds the depth of loops in the control flow graph.
 * Uses the call graph and natural loops of the control flow graph.
 */
public class Pass3LoopDepthAnalysis {

   private Program program;
   private CompileLog log;

   public Pass3LoopDepthAnalysis(Program program, CompileLog log) {
      this.program = program;
      this.log = log;
   }

   public Program getProgram() {
      return program;
   }

   public CompileLog getLog() {
      return log;
   }

   /**
    * Finds the depth of loops in the control flow graph.
    * Uses the call graph and natural loops of the control flow graph.
    */
   public void findLoopDepths() {
      CallGraph callGraph = program.getGraph().getCallGraph();
      NaturalLoopSet loopSet = program.getGraph().getLoopSet();

      Deque<LabelRef> todo = new ArrayDeque<>();
      Set<LabelRef> done = new LinkedHashSet<>();
      todo.push(callGraph.getFirstCallBlock());
      while(!todo.isEmpty()) {
         LabelRef currentScope = todo.pop();
         done.add(currentScope);
         CallGraph.CallBlock currentCallBlock = callGraph.getOrCreateCallBlock(currentScope);
         // Add called sub blocks for later processing
         Collection<LabelRef> subBlocks = currentCallBlock.getCalledBlocks();
         for (LabelRef subBlock : subBlocks) {
            if (!done.contains(subBlock) && !todo.contains(subBlock)) {
               todo.add(subBlock);
            }
         }
         // Find the scope blocks calling the current scope block - and the loop depth of the blocks where the call statement is
         int callingDepth = 1;
         Collection<LabelRef> callingScopes = callGraph.getCallingBlocks(currentScope);
         for (LabelRef callingScope : callingScopes) {
            CallGraph.CallBlock callingBlock = callGraph.getOrCreateCallBlock(callingScope);
            Collection<CallGraph.CallBlock.Call> calls = callingBlock.getCalls(currentScope);
            for (CallGraph.CallBlock.Call call : calls) {
               int callStatementIdx = call.getCallStatementIdx();
               ControlFlowBlock callingControlBlock = program.getGraph().getBlockFromStatementIdx(callStatementIdx);
               Collection<NaturalLoop> callingLoops = loopSet.getLoopsContainingBlock(callingControlBlock.getLabel());
               for (NaturalLoop callingLoop : callingLoops) {
                  int potentialDepth = callingLoop.getDepth()+1;
                  if(potentialDepth >callingDepth) {
                     callingDepth = potentialDepth;
                  }
               }
            }
         }
         findLoopDepth(currentScope, callingDepth);
      }
   }

   private void findLoopDepth(LabelRef currentScope, int initialDepth) {
      NaturalLoopSet loopSet = program.getGraph().getLoopSet();
      // Find loops in the current scope block
      List<NaturalLoop> currentScopeLoops = new ArrayList<>();
      for (NaturalLoop loop : loopSet.getLoops()) {
         LabelRef loopHead = loop.getHead();
         ControlFlowBlock loopHeadBlock = program.getGraph().getBlock(loopHead);
         LabelRef scopeRef = Pass3CallGraphAnalysis.getScopeRef(loopHeadBlock, program);
         if(scopeRef.equals(currentScope)) {
            // Loop is inside current scope block!
            currentScopeLoops.add(loop);
         }
      }

      log.append("Found "+currentScopeLoops.size()+" loops in scope ["+currentScope.toString()+"]");
      for (NaturalLoop loop : currentScopeLoops) {
         log.append("  "+loop.toString());
      }

      // Find loop nesting depths in current scope loops
      Deque<NaturalLoop> todo = new ArrayDeque<>();
      Set<NaturalLoop> done = new LinkedHashSet<>();
      todo.addAll(currentScopeLoops);
      while(!todo.isEmpty()) {
         NaturalLoop loop = todo.getFirst();
         todo.removeFirst();
         // Does any unprocessed loop nest this one?
         boolean postpone = false;
         for (NaturalLoop otherLoop : todo) {
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
         for (NaturalLoop otherLoop : done) {
            if(otherLoop.nests(loop)) {
               int potentialDepth = otherLoop.getDepth()+1;
               if(potentialDepth>depth) {
                  depth = potentialDepth;
               }
            }
         }
         loop.setDepth(depth);
         done.add(loop);
      }
   }


}
