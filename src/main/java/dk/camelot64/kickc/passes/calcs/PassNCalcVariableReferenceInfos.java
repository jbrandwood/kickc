package dk.camelot64.kickc.passes.calcs;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.VariableReferenceInfos;
import dk.camelot64.kickc.model.iterator.ProgramValue;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementLValue;
import dk.camelot64.kickc.model.statements.StatementPhiBlock;
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
            LinkedHashSet<SymbolVariableRef> stmtSymbolVarRefs = new LinkedHashSet<>();
            ProgramValueIterator.execute(statement,
                  (programValue, currentStmt, stmtIt, currentBlock) -> {
                     if(programValue.get() instanceof SymbolVariableRef)
                        stmtSymbolVarRefs.add((SymbolVariableRef) programValue.get());
                  }
                  , null, null);
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
            for(SymbolVariableRef referencedVarRef : stmtSymbolVarRefs) {
               if(!stmtDefinedVars.contains(referencedVarRef)) {
                  symbolVarReferences.putIfAbsent(referencedVarRef, new ArrayList<>());
                  Collection<VariableReferenceInfos.ReferenceToSymbolVar> references = symbolVarReferences.get(referencedVarRef);
                  VariableReferenceInfos.ReferenceInStatement referenceInStmt = new VariableReferenceInfos.ReferenceInStatement(statement.getIndex(), VariableReferenceInfos.ReferenceToSymbolVar.ReferenceType.USE, referencedVarRef);
                  references.add(referenceInStmt);
                  stmtSymbols.add(referenceInStmt);
                  if(!blockSymbols.contains(referenceInStmt)) blockSymbols.add(referenceInStmt);
               }
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
