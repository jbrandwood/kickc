package dk.camelot64.kickc.model;

import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.statements.StatementLValue;
import dk.camelot64.kickc.model.statements.StatementPhiBlock;
import dk.camelot64.kickc.model.symbols.Label;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.values.LabelRef;
import dk.camelot64.kickc.model.values.ScopeRef;
import dk.camelot64.kickc.model.values.SymbolRef;
import dk.camelot64.kickc.model.values.VariableRef;
import dk.camelot64.kickc.passes.Pass2ConstantIdentification;

import java.io.Serializable;
import java.util.*;

/**
 * The control flow graph of the program.
 * The control flow  graph is a set of connected basic blocks.
 */
public class ControlFlowGraph implements Serializable {

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
    * Get the assignment of the passed variable. Assumes that only a single assignment exists.
    *
    * @param variable The variable to find the assignment for
    * @return The assignment. null if the variable is not assigned. The variable is assigned by a Phi-statement instead.
    */
   public StatementLValue getAssignment(VariableRef variable) {
      for(ControlFlowBlock block : getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementLValue) {
               StatementLValue assignment = (StatementLValue) statement;
               if(variable.equals(assignment.getlValue())) {
                  return assignment;
               }
            }
         }
      }
      return null;
   }

   /**
    * Get all assignments of the passed variable.
    *
    * @param variable The variable to find the assignment for
    * @return All assignments.
    */
   public List<StatementLValue> getAssignments(VariableRef variable) {
      ArrayList<StatementLValue> assignments = new ArrayList<>();
      for(ControlFlowBlock block : getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementLValue) {
               StatementLValue assignment = (StatementLValue) statement;
               if(variable.equals(assignment.getlValue())) {
                  assignments.add(assignment);
               }
            }
         }
      }
      return assignments;
   }

   /**
    * Get the block containing the assignment of the passed variable. Assumes that only a single assignment exists.
    *
    * @param variable The variable to find the assignment for
    * @return The block containing the assignment. null if the variable is not assigned.
    */
   public ControlFlowBlock getAssignmentBlock(VariableRef variable) {
      for(ControlFlowBlock block : getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementLValue) {
               StatementLValue assignment = (StatementLValue) statement;
               if(variable.equals(assignment.getlValue())) {
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
         if(label.getFullName().equals(SymbolRef.MAIN_PROC_NAME)) {
            return block;
         }
      }
      return null;
   }

   /**
    * Get all blocks that are program entry points.
    * This is the main-block and any blocks referenced by the address-off operator (&)
    * @param program The program
    * @return All entry-point blocks
    */
   public List<ControlFlowBlock> getEntryPointBlocks(Program program) {
      List<ControlFlowBlock> entryPointBlocks = new ArrayList<>();
      for(Procedure procedure : program.getScope().getAllProcedures(true)) {
         if(Pass2ConstantIdentification.isAddressOfUsed(procedure.getRef(), program) || procedure.getCallingConvension().equals(Procedure.CallingConvension.STACK_CALL)) {
            // Address-of is used on the procedure
            Label procedureLabel = procedure.getLabel();
            ControlFlowBlock procedureBlock = getBlock(procedureLabel.getRef());
            entryPointBlocks.add(procedureBlock);
         }
      }

      ControlFlowBlock mainBlock = getMainBlock();
      if(mainBlock != null) {
         entryPointBlocks.add(mainBlock);
      }
      entryPointBlocks.add(getFirstBlock());
      return entryPointBlocks;
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

   /**
    * Get information about the size of the program
    * @return Size information
    */
   public String getSizeInfo() {
      StringBuilder sizeInfo = new StringBuilder();
      sizeInfo.append("SIZE blocks "+ getAllBlocks().size()).append("\n");
      int numStmt = getAllBlocks().stream().mapToInt(block -> block.getStatements().size()).sum();
      sizeInfo.append("SIZE statements "+ numStmt).append("\n");
      int numPhiVars =  getAllBlocks().stream().mapToInt(value -> value.getStatements().stream().mapToInt(value1 -> (value1 instanceof StatementPhiBlock)?((StatementPhiBlock) value1).getPhiVariables().size():0).sum()).sum();
      sizeInfo.append("SIZE phi variables "+ numPhiVars).append("\n");
      return sizeInfo.toString();
   }

}
