package dk.camelot64.kickc.icl;

/** Pass that modifies a control flow graph to call procedures by passing return value through registers */
public class Pass1ProcedureCallsReturnValue extends ControlFlowGraphCopyVisitor {

   private Scope scope;
   private ControlFlowGraph graph;

   public Pass1ProcedureCallsReturnValue(Scope scope, ControlFlowGraph graph ) {
      this.scope = scope;
      this.graph= graph;
   }

   public ControlFlowGraph generate() {
      ControlFlowGraph generated = visitGraph(graph);
      return generated;
   }

   @Override
   public StatementCallLValue visitCallLValue(StatementCallLValue origCall) {
      // Procedure strategy implemented is currently variable-based transfer of parameters/return values
      // Generate return value assignment
      Procedure procedure = origCall.getProcedure();

      String procedureName = origCall.getProcedureName();
      StatementCallLValue copyCall = new StatementCallLValue(null, procedureName, null);
      copyCall.setParametersByAssignment(true);
      copyCall.setProcedure(procedure);
      addStatementToCurrentBlock(copyCall);
      getCurrentBlock().setCallSuccessor(procedure.getLabel());

      //StatementAssignment returnAssignment = new StatementAssignment();

      return null;
   }


}
