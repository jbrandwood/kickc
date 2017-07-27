package dk.camelot64.kickc.icl;

import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

/** A set of natural loops in a control flow graph.
 * <p>For definitions and more see http://www.cs.colostate.edu/~cs553/ClassNotes/lecture09-control-dominators.ppt.pdf
 * <p>Created by {@link dk.camelot64.kickc.passes.Pass3LoopAnalysis}
 * */
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
    * @return The loops
    */
   public List<NaturalLoop> getLoops() {
      return loops;
   }

   @Override
   public String toString() {
      StringBuilder out = new StringBuilder();
      for (NaturalLoop loop : loops) {
         out.append(loop.toString());
         out.append("\n");
      }
      return out.toString();
   }

   /**
    * Get all blocks that are heads of a loop
    * @return The labels for all blocks that are head of a loop.
    */
   public Set<LabelRef> getLoopHeads() {
      LinkedHashSet<LabelRef> heads = new LinkedHashSet<>();
      for (NaturalLoop loop : loops) {
         heads.add(loop.getHead());
      }
      return heads;
   }

   /**
    * Get all loops with a given loop head
    * @param loopHead The loop head
    * @return Set with all loops that have the given head
    */
   public Set<NaturalLoop> getLoopsFromHead(LabelRef loopHead) {
      LinkedHashSet<NaturalLoop> result = new LinkedHashSet<>();
      for (NaturalLoop loop : loops) {
         if(loopHead.equals(loop.getHead())) {
            result.add(loop);
         }
      }
      return result;
   }

   /**
    * Remove a loop from the set
    * @param loop The loop to remove
    */
   public void remove(NaturalLoop loop) {
      this.loops.remove(loop);
   }
}
