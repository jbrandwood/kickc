package dk.camelot64.kickc.icl;

import java.util.Collection;
import java.util.Map;

/** The control flow graph of the program.
 * The control flow  graph is a set of connected basic blocks. */
public class ControlFlowGraph {

   private Map<Symbol, ControlFlowBlock> blocks;

   private ControlFlowBlock firstBlock;

   public ControlFlowGraph(Map<Symbol, ControlFlowBlock> blocks, ControlFlowBlock firstBlock) {
      this.blocks = blocks;
      this.firstBlock = firstBlock;
   }

   public ControlFlowBlock getBlock(Symbol symbol) {
      return blocks.get(symbol);
   }

   public ControlFlowBlock getFirstBlock() {
      return firstBlock;
   }

   @Override
   public String toString() {
      StringBuffer out = new StringBuffer();
      for (ControlFlowBlock block : blocks.values()) {
         out.append(block);
      }
      return out.toString();
   }

   public Collection<ControlFlowBlock> getAllBlocks() {
      return blocks.values();
   }
}
