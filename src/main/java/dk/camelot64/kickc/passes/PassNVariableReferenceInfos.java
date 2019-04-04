package dk.camelot64.kickc.passes;

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
public class PassNVariableReferenceInfos extends Pass2SsaOptimization {

   public PassNVariableReferenceInfos(Program program) {
      super(program);
   }

   /** Create defined/referenced maps */
   @Override
   public boolean step() {
      LinkedHashMap<LabelRef, Collection<VariableRef>> blockReferencedVars = new LinkedHashMap<>();
      LinkedHashMap<LabelRef, Collection<VariableRef>> blockUsedVars = new LinkedHashMap<>();
      LinkedHashMap<Integer, Collection<VariableRef>> stmtReferenced = new LinkedHashMap<>();
      LinkedHashMap<Integer, Collection<VariableRef>> stmtDefined = new LinkedHashMap<>();
      Map<SymbolVariableRef, Collection<VariableReferenceInfos.ReferenceToSymbolVar>> symbolVarReferences = new LinkedHashMap<>();
      for(ControlFlowBlock block : getProgram().getGraph().getAllBlocks()) {
         LabelRef blockLabel = block.getLabel();
         blockReferencedVars.put(blockLabel, getReferencedVars(blockLabel, new ArrayList<>()));
         blockUsedVars.put(blockLabel, getUsedVars(blockLabel, new ArrayList<>()));
         for(Statement statement : block.getStatements()) {
            Collection<SymbolVariableRef> referenced = getReferenced(statement);
            Collection<VariableRef> defined = getDefinedVars(statement);
            // Add variable definitions to the statement
            stmtDefined.put(statement.getIndex(), defined);
            // Identify statement defining variables
            for(VariableRef variableRef : defined) {
               symbolVarReferences.putIfAbsent(variableRef, new ArrayList<>());
               Collection<VariableReferenceInfos.ReferenceToSymbolVar> references = symbolVarReferences.get(variableRef);
               references.add(new VariableReferenceInfos.ReferenceInStatement(statement.getIndex(), VariableReferenceInfos.ReferenceToSymbolVar.ReferenceType.DEFINE, variableRef));
            }
            // Gather statements referencing variables/constants
            Collection<VariableRef> varRefs = new ArrayList<>();
            for(SymbolVariableRef referencedVarRef : referenced) {
               if(referencedVarRef instanceof VariableRef) {
                  varRefs.add((VariableRef) referencedVarRef);
               }
               if(!defined.contains(referencedVarRef)) {
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
            stmtReferenced.put(statement.getIndex(), varRefs);
         }
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
      getProgram().setVariableReferenceInfos(new VariableReferenceInfos(blockReferencedVars, blockUsedVars, stmtReferenced, stmtDefined, symbolVarReferences));
      return false;
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
    * Get all variables used inside a block and its successors (including any called method)
    *
    * @param labelRef The block to examine
    * @param visited The blocks already visited during the search. Used to stop infinite recursion
    * @return All used variables
    */
   private Collection<VariableRef> getUsedVars(LabelRef labelRef, Collection<LabelRef> visited) {
      if(labelRef == null) {
         return new ArrayList<>();
      }
      if(visited.contains(labelRef)) {
         return new ArrayList<>();
      }
      visited.add(labelRef);
      ControlFlowBlock block = getProgram().getGraph().getBlock(labelRef);
      if(block == null) {
         return new ArrayList<>();
      }
      LinkedHashSet<VariableRef> used = new LinkedHashSet<>();
      for(Statement statement : block.getStatements()) {
         used.addAll(getUsedVars(statement));
         if(statement instanceof StatementCall) {
            ProcedureRef procedure = ((StatementCall) statement).getProcedure();
            used.addAll(getUsedVars(procedure.getLabelRef(), visited));
         }
      }
      used.addAll(getUsedVars(block.getDefaultSuccessor(), visited));
      used.addAll(getUsedVars(block.getConditionalSuccessor(), visited));
      return used;
   }

   /**
    * Get all variables used or defined inside a block and its successors (including any called method)
    *
    * @param labelRef The block to examine
    * @param visited The blocks already visited during the search. Used to stop infinite recursion
    * @return All used variables
    */
   private Collection<VariableRef> getReferencedVars(LabelRef labelRef, Collection<LabelRef> visited) {
      if(labelRef == null) {
         return new ArrayList<>();
      }
      if(visited.contains(labelRef)) {
         return new ArrayList<>();
      }
      visited.add(labelRef);
      ControlFlowBlock block = getProgram().getGraph().getBlock(labelRef);
      if(block == null) {
         return new ArrayList<>();
      }
      LinkedHashSet<VariableRef> referenced = new LinkedHashSet<>();
      for(Statement statement : block.getStatements()) {
         referenced.addAll(getReferencedVars(statement));
         if(statement instanceof StatementCall) {
            ProcedureRef procedure = ((StatementCall) statement).getProcedure();
            referenced.addAll(getReferencedVars(procedure.getLabelRef(), visited));
         }
      }
      referenced.addAll(getReferencedVars(block.getDefaultSuccessor(), visited));
      referenced.addAll(getReferencedVars(block.getConditionalSuccessor(), visited));
      return referenced;
   }

   /**
    * Get the variables defined by a statement
    *
    * @param stmt The statement
    * @return Variables defined by the statement
    */
   private Collection<VariableRef> getDefinedVars(Statement stmt) {
      if(stmt instanceof StatementAssignment) {
         StatementAssignment assignment = (StatementAssignment) stmt;
         LValue lValue = assignment.getlValue();
         if(lValue instanceof VariableRef) {
            return Arrays.asList((VariableRef) lValue);
         }
      } else if(stmt instanceof StatementPhiBlock) {
         List<VariableRef> defined = new ArrayList<>();
         StatementPhiBlock phi = (StatementPhiBlock) stmt;
         for(StatementPhiBlock.PhiVariable phiVariable : phi.getPhiVariables()) {
            defined.add(phiVariable.getVariable());
         }
         return defined;
      } else if(stmt instanceof StatementCall) {
         List<VariableRef> defined = new ArrayList<>();
         if(((StatementCall) stmt).getlValue() instanceof VariableRef) {
            defined.add((VariableRef) ((StatementCall) stmt).getlValue());
         }
         return defined;
      } else if(stmt instanceof StatementCallPointer) {
         List<VariableRef> defined = new ArrayList<>();
         if(((StatementCallPointer) stmt).getlValue() instanceof VariableRef) {
            defined.add((VariableRef) ((StatementCallPointer) stmt).getlValue());
         }
         return defined;
      }
      return new ArrayList<>();
   }

   /**
    * Get the variables used, but not defined, in a statement
    *
    * @param statement The statement to examine
    * @return The used variables (not including defined variables)
    */
   private Collection<VariableRef> getUsedVars(Statement statement) {
      LinkedHashSet<VariableRef> used = new LinkedHashSet<>();
      used.addAll(getReferencedVars(statement));
      used.removeAll(getDefinedVars(statement));
      return used;
   }

   /**
    * Get the variables referenced (used or defined) in a statement
    *
    * @param statement The statement to examine
    * @return The referenced variables
    */
   private Collection<VariableRef> getReferencedVars(Statement statement) {
      LinkedHashSet<VariableRef> referencedVars = new LinkedHashSet<>();
      getReferenced(statement)
            .stream()
            .filter(symbolVariableRef -> symbolVariableRef instanceof VariableRef)
            .forEach(symbolVariableRef -> referencedVars.add((VariableRef) symbolVariableRef));
      return referencedVars;
   }

   /**
    * Get the variables / constants referenced (used or defined) in a statement
    *
    * @param statement The statement to examine
    * @return The referenced variables / constants (VariableRef / ConstantRef)
    */
   private Collection<SymbolVariableRef> getReferenced(Statement statement) {
      LinkedHashSet<SymbolVariableRef> referenced = new LinkedHashSet<>();
      ProgramValueIterator.execute(statement,
            (programValue, currentStmt, stmtIt, currentBlock) -> {
               if(programValue.get() instanceof SymbolVariableRef)
                  referenced.add((SymbolVariableRef) programValue.get());
            }
            , null, null);
      return referenced;
   }


}
