package dk.camelot64.kickc.model;

import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Dominators for a control flow graph.
 * <p>
 * Definition: Block d dominates block i if all paths from entry to block i includes block d
 * <p>
 * See http://www.cs.colostate.edu/~cs553/ClassNotes/lecture09-control-dominators.ppt.pdf
 */
public class DominatorsGraph {

   /**
    * Maps block label to the dominators of the block.
    */
   Map<LabelRef, DominatorsBlock> blockDominators;

   public DominatorsGraph() {
      this.blockDominators = new LinkedHashMap<>();
   }

   /**
    * Get the dominators for a specific block.
    *
    * @param block Label of the block
    * @return The block dominators
    */
   public DominatorsBlock getDominators(LabelRef block) {
      return blockDominators.get(block);
   }

   /**
    * Creates dominators for a specific block
    *
    * @param block Label of the block
    * @return The newly created block dominators
    */
   public DominatorsBlock addDominators(LabelRef block) {
      DominatorsBlock dominatorsBlock = new DominatorsBlock();
      this.blockDominators.put(block, dominatorsBlock);
      return dominatorsBlock;
   }


   /**
    * Set the dominators for a specific block
    *
    * @param block The block
    * @param dominators The new dominators
    */
   public void setDominators(LabelRef block, DominatorsBlock dominators) {
      blockDominators.put(block, dominators);
   }

   @Override
   public String toString() {
      StringBuilder out = new StringBuilder();
      for(LabelRef block : blockDominators.keySet()) {
         DominatorsBlock dominators = getDominators(block);
         out.append(block);
         out.append(" dominated by  ");
         out.append(dominators.toString());
         out.append("\n");
      }
      return out.toString();
   }
}
