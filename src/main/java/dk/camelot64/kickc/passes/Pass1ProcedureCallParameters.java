package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.values.LValue;
import dk.camelot64.kickc.model.values.ProcedureRef;
import dk.camelot64.kickc.model.values.RValue;
import dk.camelot64.kickc.model.values.VariableRef;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.statements.StatementCall;
import dk.camelot64.kickc.model.statements.StatementReturn;
import dk.camelot64.kickc.model.symbols.*;
import dk.camelot64.kickc.model.types.SymbolType;

import java.util.List;
import java.util.Set;

/** Pass that modifies a control flow graph to call procedures by passing parameters through registers */
public class Pass1ProcedureCallParameters extends ControlFlowGraphCopyVisitor {

   private Program program;

   public Pass1ProcedureCallParameters(Program program) {
      this.program = program;
   }

   public void generate() {
      ControlFlowGraph generated = visitGraph(program.getGraph());
      program.setGraph(generated);
   }

   private ProgramScope getScope() {
      return program.getScope();
   }

   @Override
   public StatementCall visitCall(StatementCall origCall) {
      // Procedure strategy implemented is currently variable-based transfer of parameters/return values
      // Generate parameter passing assignments
      ProcedureRef procedureRef = origCall.getProcedure();
      Procedure procedure = getScope().getProcedure(procedureRef);
      List<Variable> parameterDecls = procedure.getParameters();
      List<RValue> parameterValues = origCall.getParameters();
      for(int i = 0; i < parameterDecls.size(); i++) {
         Variable parameterDecl = parameterDecls.get(i);
         RValue parameterValue = parameterValues.get(i);
         addStatementToCurrentBlock(new StatementAssignment(parameterDecl.getRef(), parameterValue));
      }
      String procedureName = origCall.getProcedureName();
      Variable procReturnVar = procedure.getVariable("return");
      VariableRef procReturnVarRef = null;
      if(procReturnVar != null) {
         procReturnVarRef = procReturnVar.getRef();
      }
      StatementCall copyCall = new StatementCall(procReturnVarRef, procedureName, null);
      copyCall.setParametersByAssignment(true);
      copyCall.setProcedure(procedureRef);
      addStatementToCurrentBlock(copyCall);
      getCurrentBlock().setCallSuccessor(procedure.getLabel().getRef());
      Symbol currentBlockSymbol = getScope().getSymbol(getCurrentBlock().getLabel());
      Scope currentBlockScope;
      if(currentBlockSymbol instanceof Procedure) {
         currentBlockScope = (Scope) currentBlockSymbol;
      } else {
         currentBlockScope = currentBlockSymbol.getScope();
      }
      splitCurrentBlock(currentBlockScope.addLabelIntermediate().getRef());
      if(!SymbolType.VOID.equals(procedure.getReturnType()) && origCall.getlValue() != null) {
         addStatementToCurrentBlock(new StatementAssignment(origCall.getlValue(), procReturnVarRef));
      } else {
         // No return type. Remove variable receiving the result.
         LValue lValue = origCall.getlValue();
         if(lValue instanceof VariableRef) {
            VariableRef lValueRef = (VariableRef) lValue;
            Variable lValueVar = getScope().getVariable(lValueRef);
            lValueVar.getScope().remove(lValueVar);
         }
      }
      // Add self-assignments for all variables modified in the procedure
      Set<VariableRef> modifiedVars = program.getProcedureModifiedVars().getModifiedVars(procedure.getRef());
      for(VariableRef modifiedVar : modifiedVars) {
         addStatementToCurrentBlock(new StatementAssignment(modifiedVar, modifiedVar));
      }
      return null;
   }

   @Override
   public StatementReturn visitReturn(StatementReturn origReturn) {
      ControlFlowBlock currentBlock = getCurrentBlock();
      String currentProcName = currentBlock.getLabel().getScopeNames();
      Procedure procedure = program.getScope().getProcedure(currentProcName);
      // Add self-assignments for all variables modified in the procedure
      Set<VariableRef> modifiedVars = program.getProcedureModifiedVars().getModifiedVars(procedure.getRef());
      for(VariableRef modifiedVar : modifiedVars) {
         addStatementToCurrentBlock(new StatementAssignment(modifiedVar, modifiedVar));
      }
      return super.visitReturn(origReturn);
   }


}
