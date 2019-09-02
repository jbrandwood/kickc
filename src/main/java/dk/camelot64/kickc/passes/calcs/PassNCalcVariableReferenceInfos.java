package dk.camelot64.kickc.passes.calcs;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.VariableReferenceInfos;
import dk.camelot64.kickc.model.iterator.ProgramValue;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.statements.*;
import dk.camelot64.kickc.model.symbols.SymbolVariable;
import dk.camelot64.kickc.model.values.*;

import java.util.*;

/**
 * Identify variables defined/referenced for each block & statement.
 */
public class PassNCalcVariableReferenceInfos extends PassNCalcBase<VariableReferenceInfos> {

   public PassNCalcVariableReferenceInfos(Program program) {
      super(program);
   }

   private LinkedHashMap<LabelRef, Collection<VariableRef>> blockDirectVarRefsMap = null;
   private LinkedHashMap<LabelRef, Collection<VariableRef>> blockDirectUsedVarsMap = null;

   @Override
   public VariableReferenceInfos calculate() {
      LinkedHashMap<LabelRef, Collection<VariableRef>> blockReferencedVars = new LinkedHashMap<>();
      LinkedHashMap<LabelRef, Collection<VariableRef>> blockUsedVars = new LinkedHashMap<>();
      LinkedHashMap<Integer, Collection<VariableRef>> stmtReferenced = new LinkedHashMap<>();
      LinkedHashMap<Integer, Collection<VariableRef>> stmtDefined = new LinkedHashMap<>();
      Map<SymbolVariableRef, Collection<VariableReferenceInfos.ReferenceToSymbolVar>> symbolVarReferences = new LinkedHashMap<>();
      blockDirectVarRefsMap = new LinkedHashMap<>();
      blockDirectUsedVarsMap = new LinkedHashMap<>();
      for(ControlFlowBlock block : getProgram().getGraph().getAllBlocks()) {
         LinkedHashSet<VariableRef> blockDirectVarRefs = new LinkedHashSet<>();
         LinkedHashSet<VariableRef> blockDirectUsedVars = new LinkedHashSet<>();
         for(Statement statement : block.getStatements()) {
            LinkedHashSet<SymbolVariableRef> stmtSymbolVarRefs = new LinkedHashSet<>();
            LinkedHashSet<VariableRef> stmtVarRefs = new LinkedHashSet<>();
            ProgramValueIterator.execute(statement,
                  (programValue, currentStmt, stmtIt, currentBlock) -> {
                     if(programValue.get() instanceof SymbolVariableRef)
                        stmtSymbolVarRefs.add((SymbolVariableRef) programValue.get());
                     if(programValue.get() instanceof VariableRef)
                        stmtVarRefs.add((VariableRef) programValue.get());
                  }
                  , null, null);
            Collection<VariableRef> stmtDefinedVars = getDefinedVars(statement);
            LinkedHashSet<VariableRef> stmtUsedVars = new LinkedHashSet<>(stmtVarRefs);
            stmtUsedVars.removeAll(stmtDefinedVars);
            blockDirectVarRefs.addAll(stmtVarRefs);
            blockDirectUsedVars.addAll(stmtUsedVars);

            // Add variable definitions to the statement
            stmtDefined.put(statement.getIndex(), stmtDefinedVars);
            // Identify statement defining variables
            for(VariableRef variableRef : stmtDefinedVars) {
               symbolVarReferences.putIfAbsent(variableRef, new ArrayList<>());
               Collection<VariableReferenceInfos.ReferenceToSymbolVar> references = symbolVarReferences.get(variableRef);
               references.add(new VariableReferenceInfos.ReferenceInStatement(statement.getIndex(), VariableReferenceInfos.ReferenceToSymbolVar.ReferenceType.DEFINE, variableRef));
            }
            // Gather statements referencing variables/constants
            for(SymbolVariableRef referencedVarRef : stmtSymbolVarRefs) {
               if(!stmtDefinedVars.contains(referencedVarRef)) {
                  symbolVarReferences.putIfAbsent(referencedVarRef, new ArrayList<>());
                  Collection<VariableReferenceInfos.ReferenceToSymbolVar> references = symbolVarReferences.get(referencedVarRef);
                  references.add(
                        new VariableReferenceInfos.ReferenceInStatement(
                              statement.getIndex(),
                              VariableReferenceInfos.ReferenceToSymbolVar.ReferenceType.USE,
                              referencedVarRef));
               }
            }
            // Add variable reference to the statement
            stmtReferenced.put(statement.getIndex(), stmtVarRefs);
         }
         LabelRef blockLabel = block.getLabel();
         blockDirectVarRefsMap.put(blockLabel, blockDirectVarRefs);
         blockDirectUsedVarsMap.put(blockLabel, blockDirectUsedVars);
      }
      for(ControlFlowBlock block : getProgram().getGraph().getAllBlocks()) {
         LabelRef blockLabel = block.getLabel();
         LinkedHashSet<VariableRef> blockRecursiveVarRefs = new LinkedHashSet<>();
         LinkedHashSet<VariableRef> blockRecursiveUsedVars = new LinkedHashSet<>();
         addReferencedVars(block.getLabel(), block, blockRecursiveVarRefs, blockRecursiveUsedVars, new ArrayList<>());
         blockReferencedVars.put(blockLabel, blockRecursiveVarRefs);
         blockUsedVars.put(blockLabel, blockRecursiveUsedVars);
      }
      // Gather symbols in the symbol table referencing other variables/constants
      Collection<SymbolVariable> allSymbolVariables = getProgram().getScope().getAllSymbolVariables(true);
      for(SymbolVariable referencingVar : allSymbolVariables) {
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
      VariableReferenceInfos variableReferenceInfos = new VariableReferenceInfos(blockReferencedVars, blockUsedVars, stmtReferenced, stmtDefined, symbolVarReferences);
      if(getLog().isVerboseSSAOptimize()) {
         getLog().append(variableReferenceInfos.getSizeInfo());
      }
      return variableReferenceInfos;
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
    * Recursively get all variables used or defined inside a block and its successors (including any called method)
    *
    * @param labelRef The block to examine
    * @param block The block to examine (optional, saves lookup)
    * @param referencedVars the set of referenced variables
    * @param usedVars the set of referenced variables
    * @param visited The blocks already visited during the search. Used to stop infinite recursion
    */
   private void addReferencedVars(LabelRef labelRef, ControlFlowBlock block, LinkedHashSet<VariableRef> referencedVars, LinkedHashSet<VariableRef> usedVars, Collection<LabelRef> visited) {
      if(labelRef == null || visited.contains(labelRef))
         return;
      visited.add(labelRef);
      if(block == null) {
         block = getProgram().getGraph().getBlock(labelRef);
         if(block == null)
            return;
      }
      referencedVars.addAll(blockDirectVarRefsMap.get(labelRef));
      usedVars.addAll(blockDirectUsedVarsMap.get(labelRef));
      addReferencedVars(block.getDefaultSuccessor(), null, referencedVars, usedVars, visited);
      addReferencedVars(block.getConditionalSuccessor(), null, referencedVars, usedVars, visited);
      addReferencedVars(block.getCallSuccessor(), null, referencedVars, usedVars, visited);
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
