package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.values.*;
import dk.camelot64.kickc.model.statements.*;
import dk.camelot64.kickc.model.symbols.Label;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.types.SymbolType;
import org.antlr.v4.runtime.RuleContext;

import java.util.Set;

/**
 * Pass that modifies a control flow graph to call procedures by passing return value through registers
 */
public class Pass1ProcedureCallsReturnValue extends ControlFlowGraphCopyVisitor {

   private Program program;

   public Pass1ProcedureCallsReturnValue(Program program) {
      this.program = program;
   }

   public ControlFlowGraph generate() {
      ControlFlowGraph generated = visitGraph(program.getGraph());
      return generated;
   }

   @Override
   public StatementCall visitCall(StatementCall origCall) {
      // Procedure strategy implemented is currently variable-based transfer of parameters/return values
      // Generate return value assignment
      ProcedureRef procedureRef = origCall.getProcedure();
      Procedure procedure = program.getScope().getProcedure(procedureRef);
      String procedureName = origCall.getProcedureName();
      StatementCall copyCall = new StatementCall(null, procedureName, null, origCall.getSource());
      copyCall.setProcedure(procedureRef);
      addStatementToCurrentBlock(copyCall);
      getCurrentBlock().setCallSuccessor(procedure.getLabel().getRef());
      if(!SymbolType.VOID.equals(procedure.getReturnType())) {
         // Find return variable final version
         Label returnBlockLabel = procedure.getLabel(SymbolRef.PROCEXIT_BLOCK_NAME);
         ControlFlowBlock returnBlock = program.getGraph().getBlock(returnBlockLabel.getRef());
         VariableRef returnVarFinal = null;
         for(Statement statement : returnBlock.getStatements()) {
            if(statement instanceof StatementReturn) {
               StatementReturn statementReturn = (StatementReturn) statement;
               RValue returnValue = statementReturn.getValue();
               if(returnValue instanceof VariableRef) {
                  returnVarFinal = (VariableRef) returnValue;
               }
            }
         }
         if(returnVarFinal == null) {
            throw new RuntimeException("Error! Cannot find final return variable for " + procedure.getFullName());
         }
         StatementAssignment returnAssignment = new StatementAssignment(origCall.getlValue(), returnVarFinal, origCall.getSource());
         addStatementToCurrentBlock(returnAssignment);
      }

      // Patch versions of rValues in assignments for vars modified in the call
      LabelRef successor = getOrigBlock().getDefaultSuccessor();
      ControlFlowBlock successorBlock = program.getGraph().getBlock(successor);
      Set<VariableRef> modifiedVars = program.getProcedureModifiedVars().getModifiedVars(procedure.getRef());
      for(Statement statement : successorBlock.getStatements()) {
         if(statement instanceof StatementPhiBlock) {
            StatementPhiBlock phiBlock = (StatementPhiBlock) statement;
            for(StatementPhiBlock.PhiVariable phiVariable : phiBlock.getPhiVariables()) {
               VariableRef phiVar = phiVariable.getVariable();
               VariableRef unversionedVar = new VariableRef(phiVar.getFullNameUnversioned());
               if(modifiedVars.contains(unversionedVar)) {
                  for(StatementPhiBlock.PhiRValue phiRValue : phiVariable.getValues()) {
                     if(phiRValue.getPredecessor().equals(getOrigBlock().getLabel())) {
                        VariableRef procReturnVersion = findReturnVersion(procedure, unversionedVar);
                        phiRValue.setrValue(procReturnVersion);
                     }
                  }
               }
            }
         }
      }

      return null;
   }

   private VariableRef findReturnVersion(Procedure procedure, VariableRef assignedVar) {
      String unversionedName = assignedVar.getFullNameUnversioned();
      LabelRef returnBlock = new LabelRef(procedure.getRef().getFullName() + "::@return");
      ControlFlowBlock block = program.getGraph().getBlock(returnBlock);
      for(Statement statement : block.getStatements()) {
         if(statement instanceof StatementAssignment) {
            StatementAssignment assignment = (StatementAssignment) statement;
            if(assignment.getlValue() instanceof VariableRef) {
               VariableRef lValue = (VariableRef) assignment.getlValue();
               if(lValue.getFullNameUnversioned().equals(unversionedName)) {
                  return lValue;
               }
            }
         }
      }
      throw new RuntimeException("Variable " + assignedVar + "modified by procedure " + procedure + " not found in @return block " + block.getLabel());
   }

   @Override
   public StatementReturn visitReturn(StatementReturn origReturn) {
      addStatementToCurrentBlock(new StatementReturn(null, origReturn.getSource()));
      return null;
   }
}

