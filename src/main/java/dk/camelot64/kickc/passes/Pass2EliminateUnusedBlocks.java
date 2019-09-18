package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.CompileLog;
import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.statements.StatementCall;
import dk.camelot64.kickc.model.statements.StatementPhiBlock;
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
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         if(!referencedBlocks.contains(block.getLabel())) {
            unusedBlocks.add(block.getLabel());
            for(Statement stmt : block.getStatements()) {
               if(stmt instanceof StatementAssignment) {
                  StatementAssignment assignment = (StatementAssignment) stmt;
                  LValue lValue = assignment.getlValue();
                  if(lValue instanceof VariableRef) {
                     getLog().append("Eliminating variable " + lValue.toString(getProgram()) + " from unused block " + block.getLabel());
                     Variable variable = getScope().getVariable((VariableRef) lValue);
                     variable.getScope().remove(variable);
                  }
               } else if(stmt instanceof StatementPhiBlock) {
                  for(StatementPhiBlock.PhiVariable phiVariable : ((StatementPhiBlock) stmt).getPhiVariables()) {
                     VariableRef phiVar = phiVariable.getVariable();
                     getLog().append("Eliminating variable " + phiVar.toString(getProgram()) + " from unused block " + block.getLabel());
                     Variable variable = getScope().getVariable(phiVar);
                     variable.getScope().remove(variable);

                  }
               }
            }
         }
      }


      Set<LabelRef> unusedProcedureBlocks = new HashSet<>();
      for( LabelRef unusedBlock : unusedBlocks) {
         Symbol unusedSymbol = getScope().getSymbol(unusedBlock);
         if(unusedSymbol instanceof Label) {
            getGraph().remove(unusedBlock);
            Label label = getScope().getLabel(unusedBlock);
            label.getScope().remove(label);
            removePhiRValues(unusedBlock);
            getLog().append("Removing unused block " + unusedBlock);
         } else if(unusedSymbol instanceof Procedure) {
            ProcedureRef unusedProcedureRef = ((Procedure) unusedSymbol).getRef();
            getLog().append("Removing unused procedure " + unusedProcedureRef);
            Procedure unusedProcedure = getProgram().getScope().getProcedure(unusedProcedureRef);
            List<ControlFlowBlock> procedureBlocks = getProgram().getGraph().getScopeBlocks(unusedProcedureRef);
            for(ControlFlowBlock procedureBlock : procedureBlocks) {
               LabelRef blockLabelRef = procedureBlock.getLabel();
               getLog().append("Removing unused procedure block " + blockLabelRef);
               getProgram().getGraph().remove(blockLabelRef);
               removePhiRValues(blockLabelRef);
               unusedProcedureBlocks.add(blockLabelRef);
            }
            unusedProcedure.getScope().remove(unusedProcedure);
         } else if(unusedProcedureBlocks.contains(unusedBlock)) {
            // Already removed - we are happy!
         } else {
            throw new CompileError("Unable to remove unused block "+unusedBlock);
         }
      }

      return unusedBlocks.size() > 0;
   }

   /**
    * Get all referenced blocks in the entire program
    *
    * @return All blocks referenced
    */
   private Set<LabelRef> getReferencedBlocks() {
      Set<LabelRef> referencedBlocks = new LinkedHashSet<>();
      List<ControlFlowBlock> entryPointBlocks = getGraph().getEntryPointBlocks(getProgram());
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
   private void removePhiRValues(LabelRef removeBlock) {
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         removePhiRValues(removeBlock, block, getLog());
      }
   }

   /**
    * Remove all Phi RValues in phi-statements referencing the passed block
    *
    * @param removeBlock The block to remove from PHI RValues
    * @param block The block to modify
    */
   public static void removePhiRValues(LabelRef removeBlock, ControlFlowBlock block, CompileLog log) {
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
   private void findReferencedBlocks(ControlFlowBlock block, Set<LabelRef> used) {
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
   }


}
