package dk.camelot64.kickc.icl;

import java.util.ArrayList;
import java.util.List;

/** The call graph for the entire control flow graph.
 * Created by {@link dk.camelot64.kickc.passes.Pass3CallGraphAnalysis}
 * */
public class CallGraph {

   private List<CallBlock> callBlocks;


   public CallGraph() {
      this.callBlocks = new ArrayList<>();
   }

   /**
    * Get the call block for a specific scope. Create it if it does not already exist.
    * @param scopeLabel The label for the scope.
    * @return The call block for the scope
    */
   public CallBlock getOrCreateCallBlock(LabelRef scopeLabel) {
      for (CallBlock callBlock : callBlocks) {
         if(callBlock.getScopeLabel().equals(scopeLabel)) {
            return callBlock;
         }
      }
      // Not found - create it
      CallBlock newCallBlock = new CallBlock(scopeLabel);
      callBlocks.add(newCallBlock);
      return newCallBlock;
   }

   @Override
   public String toString() {
      StringBuilder out = new StringBuilder();
      for (CallBlock callBlock : callBlocks) {
         out.append(callBlock.toString()).append("\n");
      }
      return out.toString();
   }

   /** A block in the call graph, matching a scope in the program. */
   public static class CallBlock {

      /** The label of the scope. (Program scope has label "" and procedure scopes have their respective labels). */
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

      @Override
      public String toString() {
         StringBuilder out = new StringBuilder();
         out.append("Calls in [").append(scopeLabel.toString()).append("] to ");
         for (Call call : calls) {
            out.append(call.toString()).append(" ");
         }
         return out.toString();
      }

      /** A single call in the call block. */
      public static class Call {

         /** Statement index of the call statement, */
         private Integer callStatementIdx;

         /** The label of the called procedure. */
         private LabelRef procedure;

         public Call(LabelRef procedure, StatementCall statementCall) {
            this.callStatementIdx = statementCall.getIndex();
            this.procedure = procedure;
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
