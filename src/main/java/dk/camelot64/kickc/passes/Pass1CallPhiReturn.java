package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.values.*;
import dk.camelot64.kickc.model.statements.*;
import dk.camelot64.kickc.model.symbols.Label;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.types.SymbolType;

import java.util.ArrayList;
import java.util.ListIterator;
import java.util.Set;

/**
 * Handles return values for {@link Procedure.CallingConvention#PHI_CALL} procedure calls by passing the return value through variable versions.
 */
public class Pass1CallPhiReturn {

   private Program program;

   public Pass1CallPhiReturn(Program program) {
      this.program = program;
   }

   public void execute() {
      for(ControlFlowBlock block : program.getGraph().getAllBlocks()) {
         ListIterator<Statement> stmtIt = block.getStatements().listIterator();
         while(stmtIt.hasNext()) {
            Statement statement = stmtIt.next();
            if(statement instanceof StatementCall) {
               StatementCall call = (StatementCall) statement;
               ProcedureRef procedureRef = call.getProcedure();
               Procedure procedure = program.getScope().getProcedure(procedureRef);
               if(Procedure.CallingConvention.PHI_CALL.equals(procedure.getCallingConvention())) {
                  handlePhiCall(call, procedure, block, stmtIt);
               }
            }
         }
      }

      for(ControlFlowBlock block : program.getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementReturn) {
               StatementReturn statementReturn = (StatementReturn) statement;
               Procedure procedure = block.getProcedure(program);
               if(Procedure.CallingConvention.PHI_CALL.equals(procedure.getCallingConvention())) {
                  statementReturn.setValue(null);
               }
            }
         }
      }

   }


   /**
    * Handle PHI-call by assigning return value to LValue and updating all variables modified inside the procedure.
    * @param call The call statement
    * @param procedure The procedure
    * @param block The block containing the call
    * @param stmtIt Iterator used for adding statements
    */
   void handlePhiCall(StatementCall call, Procedure procedure, ControlFlowBlock block, ListIterator<Statement> stmtIt) {
      // Generate return value assignment
      block.setCallSuccessor(procedure.getLabel().getRef());
      if(!SymbolType.VOID.equals(procedure.getReturnType())) {
         // Find return variable final version
         Label returnBlockLabel = procedure.getLabel(SymbolRef.PROCEXIT_BLOCK_NAME);
         ControlFlowBlock returnBlock = program.getGraph().getBlock(returnBlockLabel.getRef());
         RValue returnVarFinal = null;
         for(Statement statement : returnBlock.getStatements()) {
            if(statement instanceof StatementReturn) {
               StatementReturn statementReturn = (StatementReturn) statement;
               RValue returnValue = statementReturn.getValue();
               if(returnValue instanceof VariableRef) {
                  returnVarFinal = returnValue;
               } else if(returnValue instanceof ValueList) {
                  returnVarFinal = returnValue;
               }
            }
         }
         if(returnVarFinal == null) {
            throw new RuntimeException("Error! Cannot find final return variable for " + procedure.getFullName());
         }
         // Add assignment of final return variable version to lValue
         if(call.getlValue()!=null) {
            StatementAssignment returnAssignment = new StatementAssignment(call.getlValue(), returnVarFinal, call.isInitialAssignment(), call.getSource(), new ArrayList<>());
            stmtIt.add(returnAssignment);
            call.setlValue(null);
         }
      }

      // Patch versions of rValues in assignments for vars modified in the call
      LabelRef successor = block.getDefaultSuccessor();
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
                     if(phiRValue.getPredecessor().equals(block.getLabel())) {
                        VariableRef procReturnVersion = findReturnVersion(procedure, unversionedVar);
                        phiRValue.setrValue(procReturnVersion);
                     }
                  }
               }
            }
         }
      }
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

}

