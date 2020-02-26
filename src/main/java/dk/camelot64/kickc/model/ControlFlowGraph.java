package dk.camelot64.kickc.model;

import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementInfos;
import dk.camelot64.kickc.model.statements.StatementPhiBlock;
import dk.camelot64.kickc.model.symbols.Label;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.values.LabelRef;
import dk.camelot64.kickc.model.values.ProcedureRef;
import dk.camelot64.kickc.model.values.ScopeRef;
import dk.camelot64.kickc.model.values.SymbolRef;
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
         if(Pass2ConstantIdentification.isAddressOfUsed(procedure.getRef(), program) || Procedure.CallingConvension.STACK_CALL.equals(procedure.getCallingConvension())) {
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
      return Objects.equals(sequence, that.sequence);
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
            if(statement.getIndex()!=null && statementIdx == statement.getIndex()) {
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

   /**
    * Get all statements executed between two statements (none of these are included in the result)
    * @param from The statement to start at
    * @param to The statement to end at
    * @return All statements executed between the two passed statements
    */
   public Collection<Statement> getStatementsBetween(Statement from, Statement to, StatementInfos statementInfos) {
      Collection<Statement> between = new LinkedHashSet<>();
      final ControlFlowBlock block = statementInfos.getBlock(from);
      populateStatementsBetween(from, to, false, between, block);
      return between;
   }

   /**
    * Fill the between collection with all statements executed between two statements (none of these are included in the result)
    * @param from The statement to start at
    * @param to The statement to end at
    * @param between The between collection
    * @param block The block to start from
    */
   private void populateStatementsBetween(Statement from, Statement to, boolean isBetween, Collection<Statement> between, ControlFlowBlock block) {
      for(Statement statement : block.getStatements()) {
         if(between.contains(statement))
            // Stop infinite recursion
            return;
         if(isBetween) {
            if(statement.equals(to))
               // The end was reached!
               isBetween = false;
            else
               // We are between - add the statement
               between.add(statement);
         } else {
            if(statement.equals(from))
               // We are now between!
               isBetween = true;
         }
      }
      if(isBetween) {
         // Recurse to successor blocks
         final Collection<LabelRef> successors = block.getSuccessors();
         for(LabelRef successor : successors) {
            if(successor.getFullName().equals(ProcedureRef.PROCEXIT_BLOCK_NAME))
               continue;
            final ControlFlowBlock successorBlock = getBlock(successor);
            populateStatementsBetween(from, to, true, between, successorBlock);
         }
      }
   }
}
