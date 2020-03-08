package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.statements.*;
import dk.camelot64.kickc.model.symbols.*;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeStruct;
import dk.camelot64.kickc.model.values.*;

import java.util.*;

/** Handle calling convention {@link Procedure.CallingConvention#PHI_CALL} by passing parameters through variables */
public class Pass1CallPhiParameters {

   private Program program;

   public Pass1CallPhiParameters(Program program) {
      this.program = program;
   }

   private Map<LabelRef, LabelRef> splitBlockMap = new LinkedHashMap<>();

   public void execute() {
      final List<ControlFlowBlock> todoBlocks = getGraph().getAllBlocks();
      List<ControlFlowBlock> doneBlocks = new ArrayList<>();

      while(!todoBlocks.isEmpty()) {
         final ControlFlowBlock block = todoBlocks.get(0);
         todoBlocks.remove(0);
         doneBlocks.add(block);

         final ListIterator<Statement> stmtIt = block.getStatements().listIterator();
         while(stmtIt.hasNext()) {
            Statement statement = stmtIt.next();
            if(statement instanceof StatementCall) {
               StatementCall call = (StatementCall) statement;
               // Generate parameter passing assignments
               ProcedureRef procedureRef = call.getProcedure();
               Procedure procedure = getScope().getProcedure(procedureRef);
               // Handle PHI-calls
               if(Procedure.CallingConvention.PHI_CALL.equals(procedure.getCallingConvention())) {
                  final ControlFlowBlock newBlock = handlePhiCall(call, procedure, stmtIt, block);
                  // The current block was split into two blocks - add the new block at the front of the todoBlocks
                  todoBlocks.add(0, newBlock);
               }
            }
            if(statement instanceof StatementReturn) {
               Procedure procedure = block.getProcedure(program);
               // Handle PHI-calls
               if(Procedure.CallingConvention.PHI_CALL.equals(procedure.getCallingConvention())) {
                  // Add self-assignments for all variables modified in the procedure
                  Set<VariableRef> modifiedVars = program.getProcedureModifiedVars().getModifiedVars(procedure.getRef());
                  stmtIt.previous();
                  for(VariableRef modifiedVar : modifiedVars) {
                     if(getScope().getVariable(modifiedVar).isKindLoadStore())
                        continue;
                     stmtIt.add(new StatementAssignment(modifiedVar, modifiedVar, false, ((StatementReturn) statement).getSource(), Comment.NO_COMMENTS));
                  }
                  stmtIt.next();
               }
            }
         }
      }
      // Update graph blocks to include the new blocks added
      program.getGraph().setAllBlocks(doneBlocks);

      // Fix phi predecessors for any blocks has a split block as predecessor
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
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
   }

   private ProgramScope getScope() {
      return program.getScope();
   }

   private ControlFlowGraph getGraph() {
      return program.getGraph();
   }

   private ControlFlowBlock handlePhiCall(StatementCall call, Procedure procedure, ListIterator<Statement> stmtIt, ControlFlowBlock block) {

      List<Variable> parameterDefs = procedure.getParameters();
      List<RValue> parameterValues = call.getParameters();
      if(parameterDefs.size() != parameterValues.size()) {
         throw new CompileError("Wrong number of parameters in call " + call.toString(program, false) + " expected " + procedure.toString(program), call);
      }

      // Add assignments for call parameters before the call (call prepare)
      if(parameterDefs.size() > 0) {
         stmtIt.previous();
         for(int i = 0; i < parameterDefs.size(); i++) {
            Variable parameterDecl = parameterDefs.get(i);
            RValue parameterValue = parameterValues.get(i);
            stmtIt.add(new StatementAssignment((LValue) parameterDecl.getRef(), parameterValue, true, call.getSource(), Comment.NO_COMMENTS));
         }
         stmtIt.next();
      }
      // Clear parameters
      call.setParameters(null);

      // Update call LValue (call finalize)
      Variable procReturnVar = procedure.getVariable("return");
      LValue procReturnVarRef = null;
      if(procReturnVar != null) {
         procReturnVarRef = (LValue) procReturnVar.getRef();
         // Special handing of struct value returns
         if(procReturnVar.getType() instanceof SymbolTypeStruct) {
            StructVariableMemberUnwinding.VariableUnwinding returnVarUnwinding = program.getStructVariableMemberUnwinding().getVariableUnwinding((VariableRef) procReturnVarRef);
            if(returnVarUnwinding != null) {
               ArrayList<RValue> unwoundReturnVars = new ArrayList<>();
               for(String memberName : returnVarUnwinding.getMemberNames()) {
                  final SymbolVariableRef memberUnwound = returnVarUnwinding.getMemberUnwound(memberName);
                  unwoundReturnVars.add(memberUnwound);
               }
               procReturnVarRef = new ValueList(unwoundReturnVars);
            }
         }
      }
      // Save original LValue and update the LValue
      final LValue origCallLValue = call.getlValue();
      call.setlValue(procReturnVarRef);

      // Create a new block in the program, splitting the current block at the call/return (call finalize)
      Scope currentBlockScope = block.getProcedure(program);
      if(currentBlockScope==null) currentBlockScope = getScope().getScope(ScopeRef.ROOT);
      LabelRef splitBlockNewLabelRef = currentBlockScope.addLabelIntermediate().getRef();
      ControlFlowBlock newBlock = new ControlFlowBlock(splitBlockNewLabelRef, block.getScope());
      splitBlockMap.put(block.getLabel(), splitBlockNewLabelRef);
      if(!SymbolType.VOID.equals(procedure.getReturnType()) && origCallLValue != null) {
         newBlock.getStatements().add(new StatementAssignment(origCallLValue, procReturnVarRef, call.isInitialAssignment(), call.getSource(), Comment.NO_COMMENTS));
      }
      // Set new block successors
      newBlock.setDefaultSuccessor(block.getDefaultSuccessor());
      newBlock.setConditionalSuccessor(block.getConditionalSuccessor());
      newBlock.setCallSuccessor(block.getCallSuccessor());
      // Set old block call successor
      block.setCallSuccessor(procedure.getRef().getLabelRef());
      // Set old block default successor to the new block
      block.setDefaultSuccessor(newBlock.getLabel());
      // Set old block conditional successor to null
      block.setConditionalSuccessor(null);
      // Add self-assignments for all variables modified in the procedure at the start of the new block
      Set<VariableRef> modifiedVars = program.getProcedureModifiedVars().getModifiedVars(procedure.getRef());
      for(VariableRef modifiedVar : modifiedVars) {
         if(getScope().getVariable(modifiedVar).isKindLoadStore())
            continue;
         newBlock.getStatements().add(new StatementAssignment(modifiedVar, modifiedVar, false, call.getSource(), Comment.NO_COMMENTS));
      }
      // Grab the rest of the statements from the old block using the iterator and put them into the new block
      while(stmtIt.hasNext()) {
         newBlock.getStatements().add(stmtIt.next());
         stmtIt.previous();
         stmtIt.remove();
      }

      return newBlock;
   }


}
