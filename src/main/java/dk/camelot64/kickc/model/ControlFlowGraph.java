package dk.camelot64.kickc.model;

import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.values.LabelRef;
import dk.camelot64.kickc.model.values.ProcedureRef;

import java.util.*;

/**
 * The control flow graph of the program.
 * The control flow  graph is a set of connected basic blocks.
 */
public class ControlFlowGraph implements Graph {

   private List<ControlFlowBlock> blocks;

   /**
    * Sequence of blocks used when generating ASM
    */
   private List<LabelRef> sequence;

   public ControlFlowGraph(List<ControlFlowBlock> blocks) {
      this.blocks = blocks;
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

   public List<Block> getAllBlocks() {
      return Collections.unmodifiableList(blocks);
   }

   public void setAllBlocks(List<ControlFlowBlock> blocks) {
      this.blocks = blocks;
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

   public List<LabelRef> getSequence() {
      return sequence;
   }

   public void setSequence(List<LabelRef> sequence) {
      if(sequence.size() != blocks.size()) {
         throw new CompileError("ERROR! Sequence does not contain all blocks from the program. Sequence: " + sequence.size() + " Blocks: " + blocks.size());
      }
      this.sequence = sequence;
      ArrayList<ControlFlowBlock> seqBlocks = new ArrayList<>();
      for(LabelRef labelRef : sequence) {
         seqBlocks.add(getBlock(labelRef));
      }
      this.blocks = seqBlocks;
   }


   @Override
   public String toString() {
      return toString(null);
   }


   @Override
   public boolean equals(Object o) {
      if(this == o) return true;
      if(o == null || getClass() != o.getClass()) return false;
      ControlFlowGraph that = (ControlFlowGraph) o;
      return Objects.equals(blocks, that.blocks) &&
            Objects.equals(sequence, that.sequence);
   }

   @Override
   public int hashCode() {
      return Objects.hash(blocks, sequence);
   }

   /**
    * Clear all statement indices,
    */
   public void clearStatementIndices() {
      for(Graph.Block block : getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            statement.setIndex(null);
         }
      }
   }

   /**
    * Get all statements executed between two statements (none of these are included in the result)
    *
    * @param from The statement to start at
    * @param to The statement to end at
    * @return All statements executed between the two passed statements
    */
   public Collection<Statement> getStatementsBetween(Statement from, Statement to, StatementInfos statementInfos) {
      Collection<Statement> between = new LinkedHashSet<>();
      final Graph.Block block = statementInfos.getBlock(from);
      populateStatementsBetween(from, to, false, between, block);
      return between;
   }

   /**
    * Fill the between collection with all statements executed between two statements (none of these are included in the result)
    *
    * @param from The statement to start at
    * @param to The statement to end at
    * @param between The between collection
    * @param block The block to start from
    */
   private void populateStatementsBetween(Statement from, Statement to, boolean isBetween, Collection<Statement> between, Graph.Block block) {
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
