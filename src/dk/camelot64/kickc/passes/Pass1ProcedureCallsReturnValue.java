package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.icl.*;

/** Pass that modifies a control flow graph to call procedures by passing return value through registers */
public class Pass1ProcedureCallsReturnValue extends ControlFlowGraphCopyVisitor {

   private ProgramScope scope;
   private ControlFlowGraph graph;

   public Pass1ProcedureCallsReturnValue(Program program) {
      this.scope = program.getScope();
      this.graph = program.getGraph();
   }

   public ControlFlowGraph generate() {
      ControlFlowGraph generated = visitGraph(graph);
      return generated;
   }

   @Override
   public StatementCall visitCall(StatementCall origCall) {
      // Procedure strategy implemented is currently variable-based transfer of parameters/return values
      // Generate return value assignment
      ProcedureRef procedureRef = origCall.getProcedure();
      Procedure procedure = (Procedure) scope.getSymbol(procedureRef);

      String procedureName = origCall.getProcedureName();
      StatementCall copyCall = new StatementCall(null, procedureName, null);
      copyCall.setParametersByAssignment(true);
      copyCall.setProcedure(procedureRef);
      addStatementToCurrentBlock(copyCall);
      getCurrentBlock().setCallSuccessor(procedure.getLabel().getRef());
      if(!SymbolTypeBasic.VOID.equals(procedure.getReturnType())) {
         // Find return variable final version
         Label returnBlockLabel = procedure.getLabel("@return");
         ControlFlowBlock returnBlock = graph.getBlock(returnBlockLabel.getRef());
         VariableRef returnVarFinal = null;
         for (Statement statement : returnBlock.getStatements()) {
            if (statement instanceof StatementReturn) {
               StatementReturn statementReturn = (StatementReturn) statement;
               RValue returnValue = statementReturn.getValue();
               if (returnValue instanceof VariableRef) {
                  returnVarFinal = (VariableRef) returnValue;
               }
            }
         }
         if (returnVarFinal == null) {
            throw new RuntimeException("Error! Cannot find final return variable for " + procedure.getFullName());
         }
         StatementAssignment returnAssignment = new StatementAssignment(origCall.getlValue(), returnVarFinal);
         addStatementToCurrentBlock(returnAssignment);
      }
      return null;
   }

}

