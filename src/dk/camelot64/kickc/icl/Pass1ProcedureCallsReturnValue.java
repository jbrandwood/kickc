package dk.camelot64.kickc.icl;

/** Pass that modifies a control flow graph to call procedures by passing return value through registers */
public class Pass1ProcedureCallsReturnValue extends ControlFlowGraphCopyVisitor {

   private Scope scope;
   private ControlFlowGraph graph;

   public Pass1ProcedureCallsReturnValue(Scope scope, ControlFlowGraph graph) {
      this.scope = scope;
      this.graph = graph;
   }

   public ControlFlowGraph generate() {
      ControlFlowGraph generated = visitGraph(graph);
      return generated;
   }

   @Override
   public StatementCall visitCall(StatementCall origCall) {
      // Procedure strategy implemented is currently variable-based transfer of parameters/return values
      // Generate return value assignment
      Procedure procedure = origCall.getProcedure();

      String procedureName = origCall.getProcedureName();
      StatementCall copyCall = new StatementCall(null, procedureName, null);
      copyCall.setParametersByAssignment(true);
      copyCall.setProcedure(procedure);
      addStatementToCurrentBlock(copyCall);
      getCurrentBlock().setCallSuccessor(procedure.getLabel());

      // Find return variable final version
      Label returnBlockLabel = procedure.getLabel("@return");
      ControlFlowBlock returnBlock = graph.getBlock(returnBlockLabel);
      VariableVersion returnVarFinal = null;
      for (Statement statement : returnBlock.getStatements()) {
         if (statement instanceof StatementReturn) {
            StatementReturn statementReturn = (StatementReturn) statement;
            RValue returnValue = statementReturn.getValue();
            if (returnValue instanceof VariableVersion) {
               returnVarFinal = (VariableVersion) returnValue;
            }
         }
      }
      if (returnVarFinal == null) {
         throw new RuntimeException("Error! Cannot find final return variable for " + procedure.getFullName());
      }
      StatementAssignment returnAssignment = new StatementAssignment(origCall.getLValue(), returnVarFinal);
      addStatementToCurrentBlock(returnAssignment);
      return null;
   }

}

