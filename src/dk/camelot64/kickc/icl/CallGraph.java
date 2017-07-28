package dk.camelot64.kickc.icl;

import java.util.ArrayList;
import java.util.Collection;
import java.util.LinkedHashSet;
import java.util.List;

/**
 * The call graph for the entire control flow graph.
 * Created by {@link dk.camelot64.kickc.passes.Pass3CallGraphAnalysis}
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
   public CallBlock getOrCreateCallBlock(LabelRef scopeLabel) {
      CallBlock callBlock = getCallBlock(scopeLabel);
      if (callBlock != null) return callBlock;
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
   private CallBlock getCallBlock(LabelRef scopeLabel) {
      for (CallBlock callBlock : callBlocks) {
         if (callBlock.getScopeLabel().equals(scopeLabel)) {
            return callBlock;
         }
      }
      return null;
   }

   public LabelRef getFirstCallBlock() {
      return new LabelRef("");
   }

   /**
    * Get sub call blocks called from a specific call block.
    * @param block The block to find subs for
    * @return The sub call blocks called from the passed block
    */
   public Collection<CallBlock> getCalledBlocks(CallBlock block) {
      Collection<LabelRef> calledLabels = block.getCalledBlocks();
      LinkedHashSet<CallBlock> called = new LinkedHashSet<>();
      for (LabelRef calledLabel : calledLabels) {
         called.add(getOrCreateCallBlock(calledLabel));
      }
      return called;
   }

   /**
    * Get all call blocks that call a specific call block
    * @param scopeLabel The label of scope (the call block)
    * @return The scope labels of call blocks that call the passed block
    */
   public Collection<LabelRef> getCallingBlocks(LabelRef scopeLabel) {
      ArrayList<LabelRef> callingBlocks = new ArrayList<>();
      for (CallBlock callBlock : callBlocks) {
         if(callBlock.getCalledBlocks().contains(scopeLabel)) {
            callingBlocks.add(callBlock.getScopeLabel());
         }
      }
      return callingBlocks;
   }

   @Override
   public String toString() {
      StringBuilder out = new StringBuilder();
      for (CallBlock callBlock : callBlocks) {
         out.append(callBlock.toString()).append("\n");
      }
      return out.toString();
   }

   /**
    * A block in the call graph, matching a scope in the program.
    */
   public static class CallBlock {

      /**
       * The label of the scope. (Program scope has label "" and procedure scopes have their respective labels).
       */
      private LabelRef scopeLabel;

      private List<Call> calls;

      public CallBlock(LabelRef scopeLabel) {
         this.scopeLabel = scopeLabel;
         this.calls = new ArrayList<>();
      }

      public LabelRef getScopeLabel() {
         return scopeLabel;
      }

      public void addCall(LabelRef procedureLabel, StatementCall statementCall) {
         this.calls.add(new Call(procedureLabel, statementCall));
      }

      /**
       * Get all call blocks called from this one.
       *
       * @return The scope labels of all call blocks called from this one.
       */
      public Collection<LabelRef> getCalledBlocks() {
         LinkedHashSet<LabelRef> called = new LinkedHashSet<>();
         for (Call call : calls) {
            called.add(call.getProcedure());
         }
         return called;
      }

      @Override
      public String toString() {
         StringBuilder out = new StringBuilder();
         out.append("Calls in [").append(scopeLabel.toString()).append("] to ");
         for (Call call : calls) {
            out.append(call.toString()).append(" ");
         }
         return out.toString();
      }

      /**
       * Get all calls
       * @return The calls
       */
      public List<Call> getCalls() {
         return calls;
      }

      /**
       * Get all calls to a specific call block
       * @param scope The scope label of the block
       * @return All calls to the passed scope
       */
      public Collection<Call> getCalls(LabelRef scope) {
         ArrayList<Call> callsToScope = new ArrayList<>();
         for (Call call : calls) {
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
          * The label of the called procedure.
          */
         private LabelRef procedure;

         public Call(LabelRef procedure, StatementCall statementCall) {
            this.callStatementIdx = statementCall.getIndex();
            this.procedure = procedure;
         }

         public LabelRef getProcedure() {
            return procedure;
         }

         public Integer getCallStatementIdx() {
            return callStatementIdx;
         }

         @Override
         public String toString() {
            StringBuilder out = new StringBuilder();
            out.append(callStatementIdx).append(":").append(procedure);
            return out.toString();
         }

      }

   }
}
