package dk.camelot64.kickc.model;

import dk.camelot64.kickc.model.values.LabelRef;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

/**
 * A set of blocks
 */
public interface BlockSet {

   /**
    * Get the blocks in the set
    * @return References to the blocks
    */
   Set<LabelRef> getBlocks();

   /**
    * Get the actual blocks (not refs)
    * @param graph The control flow graph containing the blocks
    * @return The blocks of the loop (in the same order as they appear in the control flow graph.)
    */
   default public List<ControlFlowBlock> getBlocks(ControlFlowGraph graph) {
      ArrayList<ControlFlowBlock> controlFlowBlocks = new ArrayList<>();
      for(ControlFlowBlock block : graph.getAllBlocks()) {
         if(getBlocks().contains(block.getLabel())) {
            controlFlowBlocks.add(block);
         }
      }
      return controlFlowBlocks;
   }

   /**
    * Determine if a block is contained in the block set
    * @param labelRef THe label of the block
    * @return true if the block is contained in the set
    */
   default boolean contains(LabelRef labelRef) {
      return getBlocks().contains(labelRef);
   }

}
