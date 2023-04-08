package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.CompileLog;
import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Graph;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.*;
import dk.camelot64.kickc.model.symbols.Label;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.symbols.Symbol;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.values.*;

import java.util.*;

/** Pass that eliminates constant if's - they are either removed (if false) or replaces the default successor (if true). */
public class Pass2EliminateUnusedBlocks extends Pass2SsaOptimization {

   public Pass2EliminateUnusedBlocks(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      Set<LabelRef> referencedBlocks = getReferencedBlocks();
      Set<LabelRef> unusedBlocks = new LinkedHashSet<>();
      for(var block : getGraph().getAllBlocks()) {
         if(!referencedBlocks.contains(block.getLabel())) {
            unusedBlocks.add(block.getLabel());
            for(Statement stmt : block.getStatements()) {
               if(stmt instanceof StatementLValue) {
                  StatementLValue assignment = (StatementLValue) stmt;
                  LValue lValue = assignment.getlValue();
                  if(lValue instanceof VariableRef) {
                     Variable variable = getProgramScope().getVariable((VariableRef) lValue);
                     if(variable.isKindPhiVersion() || variable.isKindIntermediate()) {
                        getLog().append("Eliminating variable " + lValue.toString(getProgram()) + " from unused block " + block.getLabel());
                        variable.getScope().remove(variable);
                     }
                  }
               } else if(stmt instanceof StatementPhiBlock) {
                  for(StatementPhiBlock.PhiVariable phiVariable : ((StatementPhiBlock) stmt).getPhiVariables()) {
                     VariableRef phiVar = phiVariable.getVariable();
                     getLog().append("Eliminating variable " + phiVar.toString(getProgram()) + " from unused block " + block.getLabel());
                     Variable variable = getProgramScope().getVariable(phiVar);
                     variable.getScope().remove(variable);

                  }
               }
            }
         }
      }


      Set<LabelRef> removedBlocks = new HashSet<>();
      for(LabelRef unusedBlock : unusedBlocks) {
         Symbol unusedSymbol = getProgramScope().getSymbol(unusedBlock);
         if(unusedSymbol instanceof Label) {
            getGraph().remove(unusedBlock);
            Label label = getProgramScope().getLabel(unusedBlock);
            label.getScope().remove(label);
            removePhiRValues(unusedBlock, getProgram());
            removedBlocks.add(unusedBlock);
            getLog().append("Removing unused block " + unusedBlock);
         } else if(unusedSymbol instanceof Procedure) {
            ProcedureRef unusedProcedureRef = ((Procedure) unusedSymbol).getRef();
            removeProcedure(unusedProcedureRef, removedBlocks, getProgram());
         } else if(removedBlocks.contains(unusedBlock)) {
            // Already removed - we are happy!
         } else {
            throw new CompileError("Unable to remove unused block " + unusedBlock);
         }
      }

      return unusedBlocks.size() > 0;
   }

   /**
    * Removes an entire procedure from the program (control flow graph and symbol table)
    *
    * @param procedureRef The procedure to remove
    * @param removedBlocks A set where all removed blocks are added to.
    */
   public static void removeProcedure(ProcedureRef procedureRef, Set<LabelRef> removedBlocks, Program program) {
      program.getLog().append("Removing unused procedure " + procedureRef);
      Procedure unusedProcedure = program.getScope().getProcedure(procedureRef);
      List<Graph.Block> procedureBlocks = program.getGraph().getScopeBlocks(procedureRef);
      for(var procedureBlock : procedureBlocks) {
         LabelRef blockLabelRef = procedureBlock.getLabel();
         program.getLog().append("Removing unused procedure block " + blockLabelRef);
         program.getGraph().remove(blockLabelRef);
         removePhiRValues(blockLabelRef, program);
         removedBlocks.add(blockLabelRef);
      }
      unusedProcedure.getScope().remove(unusedProcedure);
   }

   /**
    * Get all referenced blocks in the entire program
    *
    * @return All blocks referenced
    */
   private Set<LabelRef> getReferencedBlocks() {
      Set<LabelRef> referencedBlocks = new LinkedHashSet<>();
      List<ControlFlowBlock> entryPointBlocks = getProgram().getEntryPointBlocks();
      for(ControlFlowBlock entryPointBlock : entryPointBlocks) {
         findReferencedBlocks(entryPointBlock, referencedBlocks);
      }

      return referencedBlocks;
   }

   /**
    * Remove all PHI RValues in any phi-statements referencing the passed block
    *
    * @param removeBlock The block to remove from PHI RValues
    */
   private static void removePhiRValues(LabelRef removeBlock, Program program) {
      for(var block : program.getGraph().getAllBlocks()) {
         removePhiRValues(removeBlock, block, program.getLog());
      }
   }

   /**
    * Remove all Phi RValues in phi-statements referencing the passed block
    *
    * @param removeBlock The block to remove from PHI RValues
    * @param block The block to modify
    */
   public static void removePhiRValues(LabelRef removeBlock, Graph.Block block, CompileLog log) {
      if(block.hasPhiBlock()) {
         for(StatementPhiBlock.PhiVariable phiVariable : block.getPhiBlock().getPhiVariables()) {
            ListIterator<StatementPhiBlock.PhiRValue> phiRValueIt = phiVariable.getValues().listIterator();
            while(phiRValueIt.hasNext()) {
               StatementPhiBlock.PhiRValue phiRValue = phiRValueIt.next();
               if(phiRValue.getPredecessor().equals(removeBlock)) {
                  log.append("Removing PHI-reference to removed block (" + removeBlock + ") in block " + block.getLabel());
                  phiRValueIt.remove();
               }
            }
         }
      }
   }

   /**
    * Find all referenced block labels recursively
    *
    * @param block The block to add (inc. all blocks that this block calls or jumps to)
    * @param used The blocks already discovered (not examined again)
    */
   private void findReferencedBlocks(Graph.Block block, Set<LabelRef> used) {
      if(block == null) {
         return;
      }
      if(used.contains(block.getLabel())) {
         return;
      }
      used.add(block.getLabel());
      if(block.getCallSuccessor() != null) {
         findReferencedBlocks(getGraph().getBlock(block.getCallSuccessor()), used);
      }
      if(block.getConditionalSuccessor() != null) {
         findReferencedBlocks(getGraph().getBlock(block.getConditionalSuccessor()), used);
      }
      if(block.getDefaultSuccessor() != null) {
         if(block.getDefaultSuccessor().getFullName().equals(SymbolRef.PROCEXIT_BLOCK_NAME)) {
            return;
         }
         findReferencedBlocks(getGraph().getBlock(block.getDefaultSuccessor()), used);
      }
      for(Statement statement : block.getStatements()) {
         if(statement instanceof StatementCall) {
            final ProcedureRef procedure = ((StatementCall) statement).getProcedure();
            findReferencedBlocks(getGraph().getBlock(procedure.getLabelRef()), used);
         } else if(statement instanceof StatementCallExecute) {
            final ProcedureRef procedure = ((StatementCallExecute) statement).getProcedure();
            if(procedure != null) {
               findReferencedBlocks(getGraph().getBlock(procedure.getLabelRef()), used);
            }
         }
      }
   }


}
