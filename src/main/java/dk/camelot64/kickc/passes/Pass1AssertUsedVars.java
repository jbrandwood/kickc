package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.VariableReferenceInfos;
import dk.camelot64.kickc.model.iterator.ProgramValue;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.statements.*;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.values.LabelRef;
import dk.camelot64.kickc.model.values.SymbolRef;
import dk.camelot64.kickc.model.values.SymbolVariableRef;
import dk.camelot64.kickc.model.values.VariableRef;

import java.util.ArrayList;
import java.util.Collection;
import java.util.LinkedHashSet;

/**
 * Checks that all used variables are assigned a value before their use
 */
public class Pass1AssertUsedVars extends Pass1Base {

   public Pass1AssertUsedVars(Program program) {
      super(program);
   }

   @Override
   public boolean step() {

      new PassNStatementIndices(getProgram()).execute();
      getProgram().clearVariableReferenceInfos();
      getProgram().clearControlFlowBlockSuccessorClosure();
      VariableReferenceInfos referenceInfos = getProgram().getVariableReferenceInfos();

      ControlFlowBlock startBlock = getProgram().getGraph().getBlock(new LabelRef(SymbolRef.START_PROC_NAME));
      final LinkedHashSet<SymbolVariableRef> defined = new LinkedHashSet<>();
      // Add all variables with an init-value
      for(Variable var : getScope().getAllVars(true)) {
         if(var.getInitValue()!=null) {
            defined.add(var.getRef());
         }
      }
      assertUsedVars(startBlock, null, referenceInfos, defined, new LinkedHashSet<>());
      getProgram().clearVariableReferenceInfos();
      getProgram().clearControlFlowBlockSuccessorClosure();
      getProgram().clearStatementIndices();
      return false;
   }


   /**
    * Assert that all used vars have been assigned values before the use.
    * Follow the control flow of the graph recursively.
    *
    * @param block The block to examine
    * @param predecessor The block jumping into this block (used for phi analysis)
    * @param referenceInfos Information about assigned/used variables in statements
    * @param defined Variables already assigned a value at the point of the first execution of the block
    * @param visited Blocks already visited
    */
   public void assertUsedVars(ControlFlowBlock block, LabelRef predecessor, VariableReferenceInfos referenceInfos, Collection<SymbolVariableRef> defined, Collection<LabelRef> visited) {
      // If the block has a phi statement it is always examined (to not skip any of the predecessor checks)
      assertUsedVarsPhi(block, predecessor, referenceInfos, defined);
      // If we have already visited the block - skip it
      if(visited.contains(block.getLabel())) {
         return;
      }
      visited.add(block.getLabel());
      // Examine all statements (except the potential PHI)
      for(Statement statement : block.getStatements()) {
         // PHI block has already been examined
         if(statement instanceof StatementPhiBlock) continue;
         Collection<VariableRef> used = referenceInfos.getUsedVars(statement);
         for(VariableRef usedRef : used) {
            if(!defined.contains(usedRef)) {
               throw new CompileError("Variable used before being defined " + usedRef.toString(getProgram()) + " in " + statement.toString(getProgram(), false), statement.getSource());
            }
         }
         Collection<VariableRef> defd = referenceInfos.getDefinedVars(statement);
         for(VariableRef definedRef : defd) {
            defined.add(definedRef);
         }
         if(statement instanceof StatementCall) {
            StatementCall call = (StatementCall) statement;
            Procedure procedure = getProgram().getScope().getProcedure(call.getProcedure());
            for(String paramName : procedure.getParameterNames()) {
               defined.add(procedure.getLocalVariable(paramName).getRef());
            }
            ControlFlowBlock procedureStart = getProgram().getGraph().getBlock(call.getProcedure().getLabelRef());
            assertUsedVars(procedureStart, block.getLabel(), referenceInfos, defined, visited);
         } else if(statement instanceof StatementCallPrepare) {
            StatementCallPrepare call = (StatementCallPrepare) statement;
            Procedure procedure = getProgram().getScope().getProcedure(call.getProcedure());
            for(String paramName : procedure.getParameterNames()) {
               defined.add(procedure.getLocalVariable(paramName).getRef());
            }
         } else if(statement instanceof StatementCallExecute) {
            StatementCallExecute call = (StatementCallExecute) statement;
            ControlFlowBlock procedureStart = getProgram().getGraph().getBlock(call.getProcedure().getLabelRef());
            assertUsedVars(procedureStart, block.getLabel(), referenceInfos, defined, visited);
         } else if(statement instanceof StatementConditionalJump) {
            StatementConditionalJump cond = (StatementConditionalJump) statement;
            ControlFlowBlock jumpTo = getProgram().getGraph().getBlock(cond.getDestination());
            assertUsedVars(jumpTo, block.getLabel(), referenceInfos, defined, visited);
         }
      }
      ControlFlowBlock successor = getProgram().getGraph().getBlock(block.getDefaultSuccessor());
      if(successor != null) {
         assertUsedVars(successor, block.getLabel(), referenceInfos, defined, visited);
      }
   }

   /**
    * Assert that all used vars have been assigned values before the use - in a PHI block.
    *
    * @param block The block to examine
    * @param predecessor The block jumping into this block (used for phi analysis)
    * @param referenceInfos Information about assigned/used variables in statements
    * @param defined Variables already assigned a value at the point of the first execution of the block
    * @param visited Blocks already visited
    */

   private void assertUsedVarsPhi(ControlFlowBlock block, LabelRef predecessor, VariableReferenceInfos referenceInfos, Collection<SymbolVariableRef> defined) {
      if(predecessor != null && block.hasPhiBlock()) {
         StatementPhiBlock phiBlock = block.getPhiBlock();
         ArrayList<SymbolVariableRef> used = new ArrayList<>();
         for(StatementPhiBlock.PhiVariable phiVariable : phiBlock.getPhiVariables()) {
            int i = 0;
            for(StatementPhiBlock.PhiRValue phiRValue : phiVariable.getValues()) {
               if(predecessor.equals(phiRValue.getPredecessor())) {
                  ProgramValueIterator.execute(new ProgramValue.PhiValue(phiVariable, i), (programValue, currentStmt, stmtIt, currentBlock) -> {
                     if(programValue.get() instanceof SymbolVariableRef) {
                        if(!used.contains(programValue.get())) used.add((SymbolVariableRef) programValue.get());
                     }
                  }, phiBlock, null, block);
               }
               i++;
            }
         }
         // Found used variables - check that they are defined
         for(SymbolVariableRef usedRef : used) {
            if(!defined.contains(usedRef)) {
               throw new CompileError("Variable used before being defined " + usedRef.toString(getProgram()) + " in " + phiBlock.toString(getProgram(), false), phiBlock.getSource());
            }
         }
         // Add all variables fefined by the PHI block
         Collection<VariableRef> defd = referenceInfos.getDefinedVars(phiBlock);
         for(VariableRef definedRef : defd) {
            defined.add(definedRef);
         }
      }
   }

}
