package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.statements.StatementCall;
import dk.camelot64.kickc.model.statements.StatementPhiBlock;
import dk.camelot64.kickc.model.statements.StatementReturn;
import dk.camelot64.kickc.model.symbols.*;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeStruct;
import dk.camelot64.kickc.model.values.*;
import dk.camelot64.kickc.passes.unwinding.RValueUnwinding;

import java.util.*;

/** Pass that modifies a control flow graph to call {@link dk.camelot64.kickc.model.symbols.Procedure.CallingConvension#PHI_CALL} procedures by passing parameters through registers */
public class Pass1ProcedureCallParameters extends ControlFlowGraphCopyVisitor {

   private Program program;

   public Pass1ProcedureCallParameters(Program program) {
      this.program = program;
   }

   private Map<LabelRef, LabelRef> splitBlockMap = new LinkedHashMap<>();

   public void generate() {
      ControlFlowGraph generated = visitGraph(program.getGraph());

      // Fix phi predecessors for any blocks has a split block as predecessor
      for(ControlFlowBlock block : generated.getAllBlocks()) {
         if(block.hasPhiBlock()) {
            for(StatementPhiBlock.PhiVariable phiVariable : block.getPhiBlock().getPhiVariables()) {
               for(StatementPhiBlock.PhiRValue phiRValue : phiVariable.getValues()) {
                  LabelRef splitBlockNew = splitBlockMap.get(phiRValue.getPredecessor());
                  if(splitBlockNew != null) {
                     phiRValue.setPredecessor(splitBlockNew);
                  }
               }
            }
         }
      }

      program.setGraph(generated);
   }

   private ProgramScope getScope() {
      return program.getScope();
   }

   @Override
   public StatementCall visitCall(StatementCall origCall) {
      // Generate parameter passing assignments
      ProcedureRef procedureRef = origCall.getProcedure();
      Procedure procedure = getScope().getProcedure(procedureRef);
      // If not PHI-call - skip
      if(!Procedure.CallingConvension.PHI_CALL.equals(procedure.getCallingConvension())) {
         StatementCall copyCall = super.visitCall(origCall);
         copyCall.setProcedure(procedureRef);
         return copyCall;
      }

      List<Variable> parameterDecls = procedure.getParameters();
      List<RValue> parameterValues = origCall.getParameters();
      if(parameterDecls.size()!=parameterValues.size()) {
         throw new CompileError("Wrong number of parameters in call "+origCall.toString(program, false)+" expected "+procedure.toString(program), origCall);
      }
      for(int i = 0; i < parameterDecls.size(); i++) {
         Variable parameterDecl = parameterDecls.get(i);
         RValue parameterValue = parameterValues.get(i);
         addStatementToCurrentBlock(new StatementAssignment((LValue) parameterDecl.getRef(), parameterValue, true, origCall.getSource(), Comment.NO_COMMENTS));
      }
      String procedureName = origCall.getProcedureName();
      Variable procReturnVar = procedure.getVariable("return");
      LValue procReturnVarRef = null;
      if(procReturnVar != null) {
         procReturnVarRef = (LValue) procReturnVar.getRef();
         // Special handing of struct value returns
         if(procReturnVar.getType() instanceof SymbolTypeStruct) {
            StructUnwinding.VariableUnwinding returnVarUnwinding = program.getStructUnwinding().getVariableUnwinding((VariableRef) procReturnVarRef);
            if(returnVarUnwinding!=null) {
               ArrayList<RValue> unwoundReturnVars = new ArrayList<>();
               for(String memberName : returnVarUnwinding.getMemberNames()) {
                  RValueUnwinding memberUnwinding = returnVarUnwinding.getMemberUnwinding(memberName);
                  unwoundReturnVars.add(memberUnwinding.getUnwinding(getScope()));
               }
               procReturnVarRef = new ValueList(unwoundReturnVars);
            }
         }
      }

      StatementCall copyCall = new StatementCall(procReturnVarRef, procedureName, null, origCall.getSource(), Comment.NO_COMMENTS);
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
      LabelRef splitBlockNewLabelRef = currentBlockScope.addLabelIntermediate().getRef();
      splitCurrentBlock(splitBlockNewLabelRef);
      splitBlockMap.put(this.getOrigBlock().getLabel(), splitBlockNewLabelRef);
      if(!SymbolType.VOID.equals(procedure.getReturnType()) && origCall.getlValue() != null) {
         addStatementToCurrentBlock(new StatementAssignment(origCall.getlValue(), procReturnVarRef, origCall.isInitialAssignment(), origCall.getSource(), Comment.NO_COMMENTS));
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
         if(getScope().getVariable(modifiedVar).isKindLoadStore())
            continue;
         addStatementToCurrentBlock(new StatementAssignment(modifiedVar, modifiedVar, false, origCall.getSource(), Comment.NO_COMMENTS));
      }
      return null;
   }

   @Override
   public StatementReturn visitReturn(StatementReturn orig) {
      ControlFlowBlock currentBlock = getCurrentBlock();
      String currentProcName = currentBlock.getLabel().getScopeNames();
      Procedure procedure = program.getScope().getProcedure(currentProcName);
      // If not PHI-call - skip
      if(!Procedure.CallingConvension.PHI_CALL.equals(procedure.getCallingConvension()))
         return super.visitReturn(orig);

      // Add self-assignments for all variables modified in the procedure
      Set<VariableRef> modifiedVars = program.getProcedureModifiedVars().getModifiedVars(procedure.getRef());
      for(VariableRef modifiedVar : modifiedVars) {
         if(getScope().getVariable(modifiedVar).isKindLoadStore())
            continue;
         addStatementToCurrentBlock(new StatementAssignment(modifiedVar, modifiedVar, false, orig.getSource(), Comment.NO_COMMENTS));
      }
      return super.visitReturn(orig);
   }


}
