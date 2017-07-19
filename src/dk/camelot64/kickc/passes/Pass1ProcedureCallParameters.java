package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.icl.*;

import java.util.List;

/** Pass that modifies a control flow graph to call procedures by passing parameters through registers */
public class Pass1ProcedureCallParameters extends ControlFlowGraphCopyVisitor {

   private Scope scope;
   private ControlFlowGraph graph;

   public Pass1ProcedureCallParameters(Scope scope, ControlFlowGraph graph ) {
      this.scope = scope;
      this.graph= graph;
   }

   public ControlFlowGraph generate() {
      ControlFlowGraph generated = visitGraph(graph);
      return generated;
   }

   @Override
   public StatementCall visitCall(StatementCall origCall) {
      // Procedure strategy implemented is currently variable-based transfer of parameters/return values
      // Generate parameter passing assignments
      Procedure procedure = origCall.getProcedure();
      List<Variable> parameterDecls = procedure.getParameters();
      List<RValue> parameterValues = origCall.getParameters();
      for (int i = 0; i < parameterDecls.size(); i++) {
         Variable parameterDecl = parameterDecls.get(i);
         RValue parameterValue = parameterValues.get(i);
         addStatementToCurrentBlock(new StatementAssignment(new VariableRef(parameterDecl), parameterValue));
      }
      String procedureName = origCall.getProcedureName();
      Variable procReturnVar = procedure.getVariable("return");
      VariableRef procReturnVarRef = null;
      if(procReturnVar!=null) {new VariableRef(procReturnVar); }
      StatementCall copyCall = new StatementCall(procReturnVarRef, procedureName, null);
      copyCall.setParametersByAssignment(true);
      copyCall.setProcedure(procedure);
      addStatementToCurrentBlock(copyCall);
      getCurrentBlock().setCallSuccessor(procedure.getLabel());
      splitCurrentBlock(scope.addLabelIntermediate());
      if(!SymbolTypeBasic.VOID.equals(procedure.getReturnType())) {
         addStatementToCurrentBlock(new StatementAssignment(origCall.getlValue(), procReturnVarRef));
      } else {
         // No return type. Remove variable receiving the result.
         LValue lValue = origCall.getlValue();
         if(lValue instanceof VariableRef) {
            VariableRef lValueRef = (VariableRef) lValue;
            Variable lValueVar = scope.getVariable(lValueRef);
            lValueVar.getScope().remove(lValueVar);
         }
      }

      return null;
   }


}
