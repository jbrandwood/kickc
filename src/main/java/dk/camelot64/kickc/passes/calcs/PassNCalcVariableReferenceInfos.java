package dk.camelot64.kickc.passes.calcs;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.VariableReferenceInfos;
import dk.camelot64.kickc.model.iterator.ProgramValue;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.statements.*;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.values.*;

import java.util.*;

/**
 * Identify variables defined/referenced for each block & statement.
 */
public class PassNCalcVariableReferenceInfos extends PassNCalcBase<VariableReferenceInfos> {

   public PassNCalcVariableReferenceInfos(Program program) {
      super(program);
   }

   @Override
   public VariableReferenceInfos calculate() {
      LinkedHashMap<LabelRef, Collection<LabelRef>> blockSuccessors = new LinkedHashMap<>();

      Map<SymbolVariableRef, Collection<VariableReferenceInfos.ReferenceToSymbolVar>> symbolVarReferences = new LinkedHashMap<>();
      Map<LabelRef, Collection<VariableReferenceInfos.ReferenceToSymbolVar>> blockVarReferences = new LinkedHashMap<>();
      Map<Integer, Collection<VariableReferenceInfos.ReferenceToSymbolVar>> statementVarReferences = new LinkedHashMap<>();

      for(ControlFlowBlock block : getProgram().getGraph().getAllBlocks()) {
         blockVarReferences.putIfAbsent(block.getLabel(), new ArrayList<>());
         Collection<VariableReferenceInfos.ReferenceToSymbolVar> blockSymbols = blockVarReferences.get(block.getLabel());
         for(Statement statement : block.getStatements()) {
            Collection<SymbolVariableRef> stmtUsedVars = getUsedVars(statement);
            Collection<VariableRef> stmtDefinedVars = getDefinedVars(statement);
            // Add variable definitions to the statement
            statementVarReferences.putIfAbsent(statement.getIndex(), new ArrayList<>());
            Collection<VariableReferenceInfos.ReferenceToSymbolVar> stmtSymbols = statementVarReferences.get(statement.getIndex());
            // Identify statement defining variables
            for(VariableRef variableRef : stmtDefinedVars) {
               symbolVarReferences.putIfAbsent(variableRef, new ArrayList<>());
               Collection<VariableReferenceInfos.ReferenceToSymbolVar> varReferences = symbolVarReferences.get(variableRef);
               VariableReferenceInfos.ReferenceInStatement referenceInStmt = new VariableReferenceInfos.ReferenceInStatement(statement.getIndex(), VariableReferenceInfos.ReferenceToSymbolVar.ReferenceType.DEFINE, variableRef);
               varReferences.add(referenceInStmt);
               stmtSymbols.add(referenceInStmt);
               if(!blockSymbols.contains(referenceInStmt)) blockSymbols.add(referenceInStmt);
            }
            // Gather statements referencing variables/constants
            for(SymbolVariableRef referencedVarRef : stmtUsedVars) {
               symbolVarReferences.putIfAbsent(referencedVarRef, new ArrayList<>());
               Collection<VariableReferenceInfos.ReferenceToSymbolVar> references = symbolVarReferences.get(referencedVarRef);
               VariableReferenceInfos.ReferenceInStatement referenceInStmt = new VariableReferenceInfos.ReferenceInStatement(statement.getIndex(), VariableReferenceInfos.ReferenceToSymbolVar.ReferenceType.USE, referencedVarRef);
               references.add(referenceInStmt);
               stmtSymbols.add(referenceInStmt);
               if(!blockSymbols.contains(referenceInStmt)) blockSymbols.add(referenceInStmt);
            }
         }
      }
      for(ControlFlowBlock block : getProgram().getGraph().getAllBlocks()) {
         LabelRef blockLabel = block.getLabel();
         LinkedHashSet<LabelRef> successorClosure = new LinkedHashSet<>();
         findSuccessorClosure(block.getLabel(), successorClosure, new ArrayList<>());
         blockSuccessors.put(blockLabel, successorClosure);
      }
      // Gather symbols in the symbol table referencing other variables/constants
      Collection<Variable> allVariables = getProgram().getScope().getAllVars(true);
      for(Variable referencingVar : allVariables) {
         ProgramValueIterator.execute(referencingVar,
               (programValue, currentStmt, stmtIt, currentBlock) -> {
                  Value rValue = programValue.get();
                  if(rValue instanceof SymbolVariableRef) {
                     SymbolVariableRef referencedVar = (SymbolVariableRef) rValue;
                     symbolVarReferences.putIfAbsent(referencedVar, new ArrayList<>());
                     Collection<VariableReferenceInfos.ReferenceToSymbolVar> references = symbolVarReferences.get(referencedVar);
                     references.add(new VariableReferenceInfos.ReferenceInSymbol((SymbolVariableRef) referencingVar.getRef(), VariableReferenceInfos.ReferenceToSymbolVar.ReferenceType.USE, referencedVar));
                  }
               });
      }
      return new VariableReferenceInfos(blockSuccessors, symbolVarReferences, blockVarReferences, statementVarReferences);
   }

   /**
    * Get all used vars in a statement.
    * This is all referenced vars - but not the variable that is assigned (unless it is also referenced elsewhere in the statement).
    *
    * @param statement The statement
    * @return All used vars
    */
   public static Collection<SymbolVariableRef> getUsedVars(Statement statement) {
      LinkedHashSet<SymbolVariableRef> usedVars = new LinkedHashSet<>();
      if(statement instanceof StatementLValue) {
         final StatementLValue statementLValue = (StatementLValue) statement;
         if(!((statementLValue).getlValue() instanceof VariableRef)) {
            // No assignments - find all vars referenced
            usedVars.addAll(getReferenced((statementLValue).getlValue()));
         }
         if(statementLValue instanceof StatementAssignment) {
            usedVars.addAll(getReferenced(((StatementAssignment) statementLValue).getrValue1()));
            usedVars.addAll(getReferenced(((StatementAssignment) statementLValue).getrValue2()));
         } else if(statementLValue instanceof StatementCall) {
            if(((StatementCall) statement).getParameters() != null)
               for(RValue parameter : ((StatementCall) statementLValue).getParameters()) {
                  usedVars.addAll(getReferenced(parameter));
               }
         } else if(statementLValue instanceof StatementCallPointer) {
            usedVars.addAll(getReferenced(((StatementCallPointer) statementLValue).getProcedure()));
            if(((StatementCallPointer) statement).getParameters() != null)
               for(RValue parameter : ((StatementCallPointer) statementLValue).getParameters()) {
                  usedVars.addAll(getReferenced(parameter));
               }
         } else if(statementLValue instanceof StatementCallFinalize) {
            // No vars
         } else {
            throw new InternalError("Statement type not handled " + statementLValue);
         }
      } else if(statement instanceof StatementPhiBlock) {
         for(StatementPhiBlock.PhiVariable phiVariable : ((StatementPhiBlock) statement).getPhiVariables()) {
            for(StatementPhiBlock.PhiRValue value : phiVariable.getValues()) {
               usedVars.addAll(getReferenced(value.getrValue()));
            }
         }
      } else {
         // No assignments - find all vars referenced
         ProgramValueIterator.execute(statement,
               (programValue, currentStmt, stmtIt, currentBlock) -> {
                  if(programValue.get() instanceof SymbolVariableRef)
                     usedVars.add((SymbolVariableRef) programValue.get());
               }
               , null, null);
      }
      return usedVars;
   }

   /**
    * Get all variables referenced in an rValue
    *
    * @param rValue The rValue
    * @return All referenced variables
    */
   public static Collection<VariableRef> getReferencedVars(RValue rValue) {
      LinkedHashSet<VariableRef> referencedVars = new LinkedHashSet<>();
      for(SymbolRef symbolRef : getReferenced(rValue)) {
         if(symbolRef instanceof VariableRef) {
            referencedVars.add((VariableRef) symbolRef);
         }
      }
      return referencedVars;
   }

   /**
    * Get all constants referenced in an rValue
    *
    * @param rValue The rValue
    * @return All referenced constants
    */
   public static Collection<ConstantRef> getReferencedConsts(RValue rValue) {
      LinkedHashSet<ConstantRef> referencedConsts = new LinkedHashSet<>();
      for(SymbolRef symbolRef : getReferenced(rValue)) {
         if(symbolRef instanceof ConstantRef) {
            referencedConsts.add((ConstantRef) symbolRef);
         }
      }
      return referencedConsts;
   }

   /**
    * Get all variables /constants referenced in an rValue
    *
    * @param rValue The rValue
    * @return All referenced variables / constants
    */
   private static Collection<SymbolVariableRef> getReferenced(RValue rValue) {
      Collection<SymbolVariableRef> referenced = new LinkedHashSet<>();
      if(rValue != null)
         ProgramValueIterator.execute(new ProgramValue.GenericValue(rValue), (programValue, currentStmt, stmtIt, currentBlock) -> {
            if(programValue.get() instanceof SymbolVariableRef) {
               referenced.add((SymbolVariableRef) programValue.get());
            }
         }, null, null, null);
      return referenced;
   }

   /**
    * Recursively get all blocks in the closure of successors & calls for a specific block
    *
    * @param labelRef The block to examine
    * @param successorClosure the set of all blocks that are successors (including called methods).
    * @param visited The blocks already visited during the search. Used to stop infinite recursion.
    */
   private void findSuccessorClosure(LabelRef labelRef, LinkedHashSet<LabelRef> successorClosure, Collection<LabelRef> visited) {
      if(labelRef == null || visited.contains(labelRef))
         return;
      visited.add(labelRef);
      ControlFlowBlock block = getProgram().getGraph().getBlock(labelRef);
      if(block == null)
         return;
      successorClosure.add(labelRef);
      findSuccessorClosure(block.getDefaultSuccessor(), successorClosure, visited);
      findSuccessorClosure(block.getConditionalSuccessor(), successorClosure, visited);
      findSuccessorClosure(block.getCallSuccessor(), successorClosure, visited);
      // Also handle stack-calls
      for(Statement statement : block.getStatements()) {
         if(statement instanceof StatementCallExecute) {
            final ProcedureRef calledProcRef = ((StatementCallExecute) statement).getProcedure();
            findSuccessorClosure(calledProcRef.getLabelRef(), successorClosure, visited);
         }
      }
   }


   /**
    * Get the variables defined by a statement
    *
    * @param stmt The statement
    * @return Variables defined by the statement
    */
   public static Collection<VariableRef> getDefinedVars(Statement stmt) {
      if(stmt instanceof StatementPhiBlock) {
         List<VariableRef> defined = new ArrayList<>();
         StatementPhiBlock phi = (StatementPhiBlock) stmt;
         for(StatementPhiBlock.PhiVariable phiVariable : phi.getPhiVariables()) {
            defined.add(phiVariable.getVariable());
         }
         return defined;
      } else if(stmt instanceof StatementLValue) {
         LValue lValue = ((StatementLValue) stmt).getlValue();
         if(lValue instanceof VariableRef) {
            return Collections.singletonList((VariableRef) lValue);
         }
      }
      return new ArrayList<>();
   }

}
