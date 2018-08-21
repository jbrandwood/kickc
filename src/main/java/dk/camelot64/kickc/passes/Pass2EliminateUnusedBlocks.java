package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.CompileLog;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.statements.StatementPhiBlock;
import dk.camelot64.kickc.model.symbols.Label;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.values.LValue;
import dk.camelot64.kickc.model.values.LabelRef;
import dk.camelot64.kickc.model.values.SymbolRef;
import dk.camelot64.kickc.model.values.VariableRef;

import java.util.LinkedHashSet;
import java.util.List;
import java.util.ListIterator;
import java.util.Set;

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
         if(!referencedBlocks.contains(block.getLabel()) ) {
            unusedBlocks.add(block.getLabel());
            for(Statement stmt : block.getStatements()) {
               if(stmt instanceof StatementAssignment) {
                  StatementAssignment assignment = (StatementAssignment) stmt;
                  LValue lValue = assignment.getlValue();
                  if(lValue instanceof VariableRef) {
                     getLog().append("Eliminating variable " + lValue.toString(getProgram()) + " and from unused block " + block.getLabel());
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
      for(LabelRef unusedBlock : unusedBlocks) {
         getGraph().remove(unusedBlock);
         Label label = getScope().getLabel(unusedBlock);
         label.getScope().remove(label);
         removePhiRValues(unusedBlock);
         getLog().append("Removing unused block "+unusedBlock);
      }
      return unusedBlocks.size()>0;
   }

   /**
    * Get all referenced blocks in the entire program
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
                  log.append("Removing PHI-reference to removed block ("+removeBlock+") in block "+block.getLabel());
                  phiRValueIt.remove();
               }
            }
         }
      }
   }

   /**
    * Find all referenced block labels recursively
    * @param block The block to add (inc. all blocks that this block calls or jumps to)
    * @param used The blocks already discovered (not examined again)
    */
   private void findReferencedBlocks(ControlFlowBlock block, Set<LabelRef> used) {
      if(block==null) {
         return;
      }
      if(used.contains(block.getLabel())) {
         return;
      }
      used.add(block.getLabel());
      if(block.getCallSuccessor()!=null) {
         findReferencedBlocks(getGraph().getBlock(block.getCallSuccessor()), used);
      }
      if(block.getConditionalSuccessor()!=null) {
         findReferencedBlocks(getGraph().getBlock(block.getConditionalSuccessor()), used);
      }
      if(block.getDefaultSuccessor()!=null) {
         if(block.getDefaultSuccessor().getFullName().equals(SymbolRef.PROCEXIT_BLOCK_NAME)) {
            return;
         }
         findReferencedBlocks(getGraph().getBlock(block.getDefaultSuccessor()), used);
      }
   }


}
