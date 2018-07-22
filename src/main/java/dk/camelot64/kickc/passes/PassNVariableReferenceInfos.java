package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.VariableReferenceInfos;
import dk.camelot64.kickc.model.iterator.ProgramValue;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.statements.*;
import dk.camelot64.kickc.model.symbols.ConstantVar;
import dk.camelot64.kickc.model.values.*;

import java.util.*;

/**
 * Identify variables defined/referenced for each block & statement.
 */
public class PassNVariableReferenceInfos extends Pass2Base {

   public PassNVariableReferenceInfos(Program program) {
      super(program);
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

   /** Create defined/referenced maps */
   public void generateVariableReferenceInfos() {
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
            Collection<VariableRef> defined = getDefinedVars(statement);
            Collection<VariableRef> referencedVars = getReferencedVars(statement);
            // Add variable definitions to the statement
            stmtDefined.put(statement.getIndex(), defined);
            // Add variable reference to the statement
            stmtReferenced.put(statement.getIndex(), referencedVars);
            // Identify statement defining variables
            for(VariableRef variableRef : defined) {
               symbolVarReferences.putIfAbsent(variableRef, new ArrayList<>());
               Collection<VariableReferenceInfos.ReferenceToSymbolVar> references = symbolVarReferences.get(variableRef);
               references.add(new VariableReferenceInfos.ReferenceInStatement(statement.getIndex(), VariableReferenceInfos.ReferenceToSymbolVar.ReferenceType.DEFINE, variableRef));
            }
            // Gather statements referencing variables
            for(VariableRef variableRef : referencedVars) {
               if(!defined.contains(variableRef)) {
                  symbolVarReferences.putIfAbsent(variableRef, new ArrayList<>());
                  Collection<VariableReferenceInfos.ReferenceToSymbolVar> references = symbolVarReferences.get(variableRef);
                  references.add(new VariableReferenceInfos.ReferenceInStatement(statement.getIndex(), VariableReferenceInfos.ReferenceToSymbolVar.ReferenceType.USE, variableRef));
               }
            }
            // Gather statements referencing constants
            Collection<ConstantRef> referencedConsts = getReferencedConsts(statement);
            for(ConstantRef constantRef : referencedConsts) {
               symbolVarReferences.putIfAbsent(constantRef, new ArrayList<>());
               Collection<VariableReferenceInfos.ReferenceToSymbolVar> references = symbolVarReferences.get(constantRef);
               references.add(new VariableReferenceInfos.ReferenceInStatement(statement.getIndex(), VariableReferenceInfos.ReferenceToSymbolVar.ReferenceType.USE, constantRef));
            }
         }
      }
      // Gather constants referencing other constants
      for(ConstantVar constantVar : getSymbols().getAllConstants(true)) {
         Collection<ConstantRef> referencedConsts = getReferencedConsts(constantVar.getValue());
         for(ConstantRef constantRef : referencedConsts) {
            symbolVarReferences.putIfAbsent(constantRef, new ArrayList<>());
            Collection<VariableReferenceInfos.ReferenceToSymbolVar> references = symbolVarReferences.get(constantRef);
            references.add(new VariableReferenceInfos.ReferenceInSymbol(constantVar.getRef(), VariableReferenceInfos.ReferenceToSymbolVar.ReferenceType.USE, constantRef));
         }
      }
      getProgram().setVariableReferenceInfos(new VariableReferenceInfos(blockReferencedVars, blockUsedVars, stmtReferenced, stmtDefined, symbolVarReferences));
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
      for(SymbolRef symbolRef : getReferenced(statement)) {
         if(symbolRef instanceof VariableRef) {
            referencedVars.add((VariableRef) symbolRef);
         }
      }
      return referencedVars;
   }

   /**
    * Get the constants referenced (used or defined) in a statement
    *
    * @param statement The statement to examine
    * @return The referenced constants
    */
   private Collection<ConstantRef> getReferencedConsts(Statement statement) {
      LinkedHashSet<ConstantRef> referencedConsts = new LinkedHashSet<>();
      for(SymbolRef symbolRef : getReferenced(statement)) {
         if(symbolRef instanceof ConstantRef) {
            referencedConsts.add((ConstantRef) symbolRef);
         }
      }
      return referencedConsts;
   }

   /**
    * Get the variables / constants referenced (used or defined) in a statement
    *
    * @param statement The statement to examine
    * @return The referenced variables / constants (VariableRef / ConstantRef)
    */
   private Collection<SymbolVariableRef> getReferenced(Statement statement) {
      LinkedHashSet<SymbolVariableRef> referenced = new LinkedHashSet<>();
      if(statement instanceof StatementPhiBlock) {
         StatementPhiBlock phiBlock = (StatementPhiBlock) statement;
         for(StatementPhiBlock.PhiVariable phiVariable : phiBlock.getPhiVariables()) {
            referenced.add(phiVariable.getVariable());
            for(StatementPhiBlock.PhiRValue phiRValue : phiVariable.getValues()) {
               referenced.addAll(getReferenced(phiRValue.getrValue()));
            }
         }
      } else if(statement instanceof StatementAssignment) {
         StatementAssignment assignment = (StatementAssignment) statement;
         referenced.addAll(getReferenced(assignment.getlValue()));
         referenced.addAll(getReferenced(assignment.getrValue1()));
         referenced.addAll(getReferenced(assignment.getrValue2()));
      } else if(statement instanceof StatementConditionalJump) {
         StatementConditionalJump conditionalJump = (StatementConditionalJump) statement;
         referenced.addAll(getReferenced(conditionalJump.getrValue1()));
         referenced.addAll(getReferenced(conditionalJump.getrValue2()));
      } else if(statement instanceof StatementCall) {
         StatementCall call = (StatementCall) statement;
         referenced.addAll(getReferenced(call.getlValue()));
         if(call.getParameters() != null) {
            for(RValue param : call.getParameters()) {
               referenced.addAll(getReferenced(param));
            }
         }
      } else if(statement instanceof StatementReturn) {
         StatementReturn statementReturn = (StatementReturn) statement;
         referenced.addAll(getReferenced(statementReturn.getValue()));
      } else if(statement instanceof StatementAsm) {
         // No references in ASM atm.
      } else if(statement instanceof StatementKickAsm) {
         // No references in ASM atm.
      } else {
         throw new RuntimeException("Unknown statement type " + statement);
      }
      return referenced;
   }


}
