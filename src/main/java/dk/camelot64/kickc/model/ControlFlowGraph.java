package dk.camelot64.kickc.model;

import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.values.LabelRef;

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

}
