package dk.camelot64.kickc.model;

import dk.camelot64.kickc.model.statements.StatementCalling;
import dk.camelot64.kickc.model.values.ProcedureRef;
import dk.camelot64.kickc.model.values.ScopeRef;
import dk.camelot64.kickc.passes.calcs.PassNCalcCallGraph;

import java.util.*;

/**
 * The call graph for the entire control flow graph.
 * Created by {@link PassNCalcCallGraph}
 */
public class CallGraph {

   private List<CallBlock> callBlocks;

   public CallGraph() {
      this.callBlocks = new ArrayList<>();
   }

   /**
    * Get the call block for a specific scope. Create it if it does not already exist.
    *
    * @param scopeLabel The label for the scope.
    * @return The call block for the scope
    */
   public CallBlock getOrCreateCallBlock(ScopeRef scopeLabel) {
      CallBlock callBlock = getCallBlock(scopeLabel);
      if(callBlock != null) {
         return callBlock;
      }
      // Not found - create it
      CallBlock newCallBlock = new CallBlock(scopeLabel);
      callBlocks.add(newCallBlock);
      return newCallBlock;
   }

   /**
    * Get the call block for a specific scope.
    *
    * @param scopeLabel The label for the scope.
    * @return The call block for the scope. Null if the call block does not exist (no calls are made from it).
    */
   public CallBlock getCallBlock(ScopeRef scopeLabel) {
      for(CallBlock callBlock : callBlocks) {
         if(callBlock.getScopeLabel().equals(scopeLabel)) {
            return callBlock;
         }
      }
      return null;
   }

   /**
    * Get sub call blocks called from a specific call block.
    *
    * @param block The block to find subs for
    * @return The sub call blocks called from the passed block
    */
   public Collection<CallBlock> getCalledBlocks(CallBlock block) {
      Collection<ScopeRef> calledLabels = block.getCalledBlocks();
      LinkedHashSet<CallBlock> called = new LinkedHashSet<>();
      for(ScopeRef calledLabel : calledLabels) {
         called.add(getOrCreateCallBlock(calledLabel));
      }
      return called;
   }

   /**
    * Get all call blocks that call a specific call block
    *
    * @param scopeLabel The label of scope (the call block)
    * @return The scope labels of call blocks that call the passed block
    */
   public Collection<ScopeRef> getCallingBlocks(ScopeRef scopeLabel) {
      ArrayList<ScopeRef> callingBlocks = new ArrayList<>();
      for(CallBlock callBlock : callBlocks) {
         if(callBlock.getCalledBlocks().contains(scopeLabel)) {
            callingBlocks.add(callBlock.getScopeLabel());
         }
      }
      return callingBlocks;
   }

   /**
    * Get the closure of all procedures called from a specific scope.
    * This includes the recursive closure of calls (ie. sub-calls and their sub-calls).
    * @param scopeRef The scope (procedure/root) to examine
    * @return All scopes called in the closure of calls
    */
   public Collection<ScopeRef> getRecursiveCalls(ScopeRef scopeRef) {
      ArrayList<ScopeRef> closure = new ArrayList<>();
      CallBlock callBlock = getCallBlock(scopeRef);
      if(callBlock!=null) {
         for(CallBlock.Call call : callBlock.getCalls()) {
            addRecursiveCalls(call.getProcedure(), closure);
         }
      }
      return closure;
   }

   /**
    * Get the closure of all procedures called from a specific scope.
    * This includes the recursive closure of calls (ie. sub-calls and their sub-calls).
    * @param scopeRef The scope (procedure/root) to examine
    * @param found The scopes already found
    */
   private void addRecursiveCalls(ScopeRef scopeRef, Collection<ScopeRef> found) {
      if(found.contains(scopeRef)) {
         // Recursion detected - stop here
         return;
      }
      found.add(scopeRef);
      CallBlock callBlock = getCallBlock(scopeRef);
      if(callBlock!=null) {
         for(CallBlock.Call call : callBlock.getCalls()) {
            addRecursiveCalls(call.getProcedure(), found);
         }
      }
   }

   @Override
   public String toString() {
      StringBuilder out = new StringBuilder();
      for(CallBlock callBlock : callBlocks) {
         out.append(callBlock.toString()).append("\n");
      }
      return out.toString();
   }

   /**
    * Get all calls of a specific procedure
    *
    * @param procedureRef The label of the procedure
    * @return All calls
    */
   public Collection<CallBlock.Call> getCallers(ProcedureRef procedureRef) {
      Collection<CallBlock.Call> callers = new ArrayList<>();
      for(CallBlock callBlock : callBlocks) {
         for(CallBlock.Call call : callBlock.getCalls()) {
            if(call.getProcedure().equals(procedureRef)) {
               callers.add(call);
            }
         }
      }
      return callers;
   }

   /**
    * Get all calls of a specific procedure
    *
    * @param procedureRef The procedure
    * @return All calls
    */
   public Collection<CallBlock.Call> getRecursiveCallers(ProcedureRef procedureRef) {
      final LinkedList<CallBlock.Call> callers = new LinkedList<>();
      Deque<ScopeRef> todo = new LinkedList<>();
      todo.add(procedureRef);
      Collection<ScopeRef> visited = new LinkedList<>();
      while(!todo.isEmpty()) {
         final ScopeRef procRef = todo.pop();
         if(visited.contains(procRef))
            continue;
         visited.add(procRef);
         if(procRef instanceof ProcedureRef) {
            final Collection<CallBlock.Call> procCallers = getCallers((ProcedureRef) procRef);
            callers.addAll(procCallers);
            for(CallBlock.Call procCaller : procCallers) {
               todo.add(procCaller.getCallStatementScope());
            }
         }
      }
      return callers;
   }

      /**
       * Get all procedures containing calls of a specific procedure
       *
       * @param label The label of the procedure
       * @return All calls
       */
   public Collection<ScopeRef> getCallerProcs(ScopeRef label) {
      Collection<ScopeRef> callers = new ArrayList<>();
      for(CallBlock callBlock : callBlocks) {
         for(CallBlock.Call call : callBlock.getCalls()) {
            if(call.getProcedure().equals(label)) {
               callers.add(callBlock.getScopeLabel());
            }
         }
      }
      return callers;
   }

   /**
    * Get the closure of all procedures calling a specific scope.
    * This includes the recursive closure of callers (ie. callers and their callers).
    * @param scopeRef The scope (procedure/root) to examine
    * @return All scopes calling the passed scope (potentially through other callers)
    */
   public Collection<ScopeRef> getRecursiveCallerProcs(ScopeRef scopeRef) {
      ArrayList<ScopeRef> closure = new ArrayList<>();
      addRecursiveCallerProcs(scopeRef, closure);
      return closure;
   }

   /**
    * Get the closure of all procedures calling a specific scope.
    * This includes the recursive closure of callers (ie. callers and their callers).
    * @param scopeRef The scope (procedure/root) to examine
    * @param found The scopes already found
    * */
   private void addRecursiveCallerProcs(ScopeRef scopeRef, Collection<ScopeRef> found) {
      if(found.contains(scopeRef)) {
         // Recursion detected - stop here
         return;
      }
      found.add(scopeRef);
      Collection<ScopeRef> callerProcs = getCallerProcs(scopeRef);
      for(ScopeRef callerProc : callerProcs) {
         addRecursiveCallerProcs(callerProc, found);
      }
   }


   /**
    * A block in the call graph, matching a scope in the program.
    */
   public static class CallBlock {

      /**
       * The scope. The top level is represented by {@link ScopeRef#ROOT}
       */
      private ScopeRef scopeLabel;

      /**
       * All direct calls from the scope.
       */
      private List<Call> calls;

      public CallBlock(ScopeRef scopeLabel) {
         this.scopeLabel = scopeLabel;
         this.calls = new ArrayList<>();
      }

      public ScopeRef getScopeLabel() {
         return scopeLabel;
      }

      public void addCall(ProcedureRef procedureLabel, StatementCalling call) {
         this.calls.add(new Call(procedureLabel, call, scopeLabel));
      }

      /**
       * Get all call blocks called from this one.
       *
       * @return The scope labels of all call blocks called from this one.
       */
      public Collection<ScopeRef> getCalledBlocks() {
         LinkedHashSet<ScopeRef> called = new LinkedHashSet<>();
         for(Call call : calls) {
            called.add(call.getProcedure());
         }
         return called;
      }

      @Override
      public String toString() {
         StringBuilder out = new StringBuilder();
         out.append("Calls in [").append(scopeLabel.toString()).append("] to ");
         for(Call call : calls) {
            out.append(call.toString()).append(" ");
         }
         return out.toString();
      }

      /**
       * Get all calls
       *
       * @return The calls
       */
      public List<Call> getCalls() {
         return calls;
      }

      /**
       * Get all calls to a specific call block
       *
       * @param scope The scope label of the block
       * @return All calls to the passed scope
       */
      public Collection<Call> getCalls(ScopeRef scope) {
         ArrayList<Call> callsToScope = new ArrayList<>();
         for(Call call : calls) {
            if(call.getProcedure().equals(scope)) {
               callsToScope.add(call);
            }
         }
         return callsToScope;
      }

      /**
       * A single call found in the call block.
       */
      public static class Call {

         /**
          * Statement index of the call statement,
          */
         private Integer callStatementIdx;

         /**
          * The calling procedure (which contains the call statement).
          */
         private ScopeRef callStatementScope;

         /**
          * The called procedure (which is itself also a Scope).
          */
         private ProcedureRef procedure;

         Call(ProcedureRef procedure, StatementCalling call, ScopeRef callStatementScope) {
            this.callStatementIdx = call.getIndex();
            this.procedure = procedure;
            this.callStatementScope = callStatementScope;
         }

         public ProcedureRef getProcedure() {
            return procedure;
         }

         public Integer getCallStatementIdx() {
            return callStatementIdx;
         }

         public ScopeRef getCallStatementScope() {
            return callStatementScope;
         }

         @Override
         public String toString() {
            StringBuilder out = new StringBuilder();
            out.append(procedure);
            if(callStatementIdx != null) {
               out.append(":").append(callStatementIdx);
            }
            return out.toString();
         }

         @Override
         public boolean equals(Object o) {
            if(this == o) return true;
            if(o == null || getClass() != o.getClass()) return false;
            Call call = (Call) o;
            return Objects.equals(callStatementIdx, call.callStatementIdx) &&
                  Objects.equals(procedure, call.procedure);
         }

         @Override
         public int hashCode() {
            return Objects.hash(callStatementIdx, procedure);
         }
      }

   }
}
