package dk.camelot64.kickc.model;

import java.util.*;

/**
 * A set of natural loops in a control flow graph.
 * <p>For definitions and more see http://www.cs.colostate.edu/~cs553/ClassNotes/lecture09-control-dominators.ppt.pdf
 * <p>Created by {@link dk.camelot64.kickc.passes.Pass3LoopAnalysis}
 */
public class NaturalLoopSet {

   private List<NaturalLoop> loops;

   public NaturalLoopSet() {
      this.loops = new ArrayList<>();
   }

   /**
    * Add a loop to the set
    *
    * @param loop The loop to add
    */
   public void addLoop(NaturalLoop loop) {
      loops.add(loop);
   }

   /**
    * Get all the loops
    *
    * @return The loops
    */
   public List<NaturalLoop> getLoops() {
      return loops;
   }

   @Override
   public String toString() {
      StringBuilder out = new StringBuilder();
      for(NaturalLoop loop : loops) {
         out.append(loop.toString());
         out.append("\n");
      }
      return out.toString();
   }

   /**
    * Get all blocks that are heads of a loop
    *
    * @return The labels for all blocks that are head of a loop.
    */
   public Set<LabelRef> getLoopHeads() {
      LinkedHashSet<LabelRef> heads = new LinkedHashSet<>();
      for(NaturalLoop loop : loops) {
         heads.add(loop.getHead());
      }
      return heads;
   }

   /**
    * Get all loops with a given loop head
    *
    * @param loopHead The loop head
    * @return Set with all loops that have the given head
    */
   public Set<NaturalLoop> getLoopsFromHead(LabelRef loopHead) {
      LinkedHashSet<NaturalLoop> result = new LinkedHashSet<>();
      for(NaturalLoop loop : loops) {
         if(loopHead.equals(loop.getHead())) {
            result.add(loop);
         }
      }
      return result;
   }

   /**
    * Get all loops containing a specific control flow graph block
    *
    * @param block The block to look for
    * @return All loops containing the block
    */
   public Collection<NaturalLoop> getLoopsContainingBlock(LabelRef block) {
      ArrayList<NaturalLoop> containing = new ArrayList<>();
      for(NaturalLoop loop : loops) {
         for(LabelRef loopBlock : loop.getBlocks()) {
            if(block.equals(loopBlock)) {
               containing.add(loop);
               break;
            }
         }
      }
      return containing;
   }


   /**
    * Remove a loop from the set
    *
    * @param loop The loop to remove
    */
   public void remove(NaturalLoop loop) {
      this.loops.remove(loop);
   }

   public int getMaxLoopDepth(LabelRef block) {
      int maxDepth = 0;
      for(NaturalLoop loop : getLoopsContainingBlock(block)) {
         if(loop.getDepth() > maxDepth) {
            maxDepth = loop.getDepth();
         }
      }
      return maxDepth;
   }
}
