package dk.camelot64.kickc.model;

import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.values.LabelRef;

import java.util.*;

/**
 * The control flow graph of the program.
 * The control flow  graph is a set of connected basic blocks.
 */
public class ControlFlowGraph implements Graph {

   private List<Graph.Block> blocks;

   /**
    * Sequence of blocks used when generating ASM
    */
   private List<LabelRef> sequence;

   public ControlFlowGraph(List<Graph.Block> blocks) {
      this.blocks = blocks;
   }

   public Graph.Block getBlock(LabelRef symbol) {
      for(var block : blocks) {
         if(block.getLabel().equals(symbol)) {
            return block;
         }
      }
      return null;
   }

   public void addBlock(Graph.Block block) {
      blocks.add(block);
   }

   public List<Block> getAllBlocks() {
      return Collections.unmodifiableList(blocks);
   }

   public void remove(LabelRef label) {
      ListIterator<Graph.Block> blocksIt = blocks.listIterator();
      while(blocksIt.hasNext()) {
         var block = blocksIt.next();
         if(block.getLabel().equals(label)) {
            blocksIt.remove();
            return;
         }
      }
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
      for(var block : getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            statement.setIndex(null);
         }
      }
   }

}
