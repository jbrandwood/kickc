package dk.camelot64.kickc.model;

import dk.camelot64.kickc.model.values.LabelRef;
import dk.camelot64.kickc.model.values.ScopeRef;
import dk.camelot64.kickc.model.values.VariableRef;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.statements.StatementPhiBlock;

import java.util.*;

/**
 * The control flow graph of the program.
 * The control flow  graph is a set of connected basic blocks.
 */
public class ControlFlowGraph {

   private List<ControlFlowBlock> blocks;
   private LabelRef firstBlockRef;

   /**
    * Sequence of blocks used when generating ASM
    */
   private List<LabelRef> sequence;

   public ControlFlowGraph(List<ControlFlowBlock> blocks, LabelRef firstBlockRef) {
      this.blocks = blocks;
      this.firstBlockRef = firstBlockRef;
   }

   public ControlFlowBlock getBlock(LabelRef symbol) {
      for(ControlFlowBlock block : blocks) {
         if(block.getLabel().equals(symbol)) {
            return block;
         }
      }
      return null;
   }

   public void addBlock(ControlFlowBlock block) {
      blocks.add(block);
   }

   public ControlFlowBlock getFirstBlock() {
      return getBlock(firstBlockRef);
   }

   public List<ControlFlowBlock> getAllBlocks() {
         return blocks;
   }

   public void remove(LabelRef label) {
      ListIterator<ControlFlowBlock> blocksIt = blocks.listIterator();
      while(blocksIt.hasNext()) {
         ControlFlowBlock block = blocksIt.next();
         if(block.getLabel().equals(label)) {
            blocksIt.remove();
            return;
         }
      }
   }

   /**
    * Get the assignment of the passed variable.
    *
    * @param variable The variable to find the assignment for
    * @return The assignment. null if the variable is not assigned. The variable is assigned by a Phi-statement instead.
    */
   public StatementAssignment getAssignment(VariableRef variable) {
      for(ControlFlowBlock block : getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) statement;
               if(assignment.getlValue().equals(variable)) {
                  return assignment;
               }
            }
         }
      }
      return null;
   }

   /**
    * Get the block containing the assignment of the passed variable.
    *
    * @param variable The variable to find the assignment for
    * @return The block containing the assignment. null if the variable is not assigned.
    */
   public ControlFlowBlock getAssignmentBlock(VariableRef variable) {
      for(ControlFlowBlock block : getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) statement;
               if(assignment.getlValue().equals(variable)) {
                  return block;
               }
            } else if(statement instanceof StatementPhiBlock) {
               for(StatementPhiBlock.PhiVariable phiVariable : ((StatementPhiBlock) statement).getPhiVariables()) {
                  if(phiVariable.getVariable().equals(variable)) {
                     return block;
                  }
               }
            }
         }
      }
      return null;
   }


   public ControlFlowBlock getDefaultSuccessor(ControlFlowBlock block) {
      if(block.getDefaultSuccessor() != null) {
         return getBlock(block.getDefaultSuccessor());
      } else {
         return null;
      }
   }

   public ControlFlowBlock getCallSuccessor(ControlFlowBlock block) {
      if(block.getCallSuccessor() != null) {
         return getBlock(block.getCallSuccessor());
      } else {
         return null;
      }
   }

   public ControlFlowBlock getConditionalSuccessor(ControlFlowBlock block) {
      if(block.getConditionalSuccessor() != null) {
         return getBlock(block.getConditionalSuccessor());
      } else {
         return null;
      }
   }


   public List<ControlFlowBlock> getPredecessors(ControlFlowBlock block) {
      ArrayList<ControlFlowBlock> predecessorBlocks = new ArrayList<>();
      for(ControlFlowBlock other : getAllBlocks()) {
         if(block.getLabel().equals(other.getDefaultSuccessor())) {
            predecessorBlocks.add(other);
         }
         if(block.getLabel().equals(other.getConditionalSuccessor())) {
            predecessorBlocks.add(other);
         }
         if(block.getLabel().equals(other.getCallSuccessor())) {
            predecessorBlocks.add(other);
         }
      }
      Collections.sort(predecessorBlocks, Comparator.comparing(o -> o.getLabel().getFullName()));
      return predecessorBlocks;
   }

   public List<LabelRef> getSequence() {
      return sequence;
   }

   public void setSequence(List<LabelRef> sequence) {
      if(sequence.size()!=blocks.size()) {
         throw new CompileError("ERROR! Sequence does not contain all blocks from the program. Sequence: "+sequence.size()+" Blocks: "+blocks.size());
      }
      this.sequence = sequence;
      ArrayList<ControlFlowBlock> seqBlocks = new ArrayList<>();
      for(LabelRef labelRef : sequence) {
         seqBlocks.add(getBlock(labelRef));
      }
      this.blocks = seqBlocks;
   }

   public ControlFlowBlock getMainBlock() {
      for(ControlFlowBlock block : getAllBlocks()) {
         LabelRef label = block.getLabel();
         if(label.getFullName().equals("main")) {
            return block;
         }
      }
      return null;
   }

   @Override
   public String toString() {
      return toString(null);
   }

   public String toString(Program program) {
      StringBuffer out = new StringBuffer();
      for(ControlFlowBlock block : getAllBlocks()) {
         out.append(block.toString(program));
      }
      return out.toString();
   }

   @Override
   public boolean equals(Object o) {
      if(this == o) return true;
      if(o == null || getClass() != o.getClass()) return false;

      ControlFlowGraph that = (ControlFlowGraph) o;

      if(!blocks.equals(that.blocks)) return false;
      if(!firstBlockRef.equals(that.firstBlockRef)) return false;
      return sequence != null ? sequence.equals(that.sequence) : that.sequence == null;
   }

   @Override
   public int hashCode() {
      int result = blocks.hashCode();
      result = 31 * result + firstBlockRef.hashCode();
      result = 31 * result + (sequence != null ? sequence.hashCode() : 0);
      return result;
   }

   /**
    * Get a statement from its statement index
    *
    * @param statementIdx The statement index
    * @return The statement
    */
   public Statement getStatementByIndex(int statementIdx) {
      for(ControlFlowBlock block : getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statementIdx == statement.getIndex()) {
               return statement;
            }
         }
      }
      return null;
   }

   /**
    * Get all blocks that are part of the execution of a specific scope. (mostly a procedure)
    *
    * @param scope The scope to find blocks for
    * @return All blocks that are part of the execution of the scope
    */
   public List<ControlFlowBlock> getScopeBlocks(ScopeRef scope) {
      ArrayList<ControlFlowBlock> scopeBlocks = new ArrayList<>();
      for(ControlFlowBlock block : getAllBlocks()) {
         if(block.getScope().equals(scope)) {
            scopeBlocks.add(block);
         }
      }
      return scopeBlocks;
   }
}
