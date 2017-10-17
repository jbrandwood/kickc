package dk.camelot64.kickc.model;

import java.util.LinkedHashSet;
import java.util.Set;

/**
 * A single natural loop in a control flow graph.
 */
public class NaturalLoop {

   /**
    * The head of the natural loop. The block where control enters the loop and the block where the back edge returns to. Dominates all nodes in the loop.
    */
   private LabelRef head;

   /**
    * The tail(s) of the natural loop. The source(s) of the back edge.
    * Normally there is only one tail in a loop - but loops with multiple tails occur when the loop body is split. An example
    * <code>while(i!=0) { if(i<5) { tail1; } else { tail2; }}</code>
    */
   private Set<LabelRef> tails;

   /**
    * The blocks of the natural loop (including head and tail)
    */
   private Set<LabelRef> blocks;

   /** The loop nesting depth of the loop. Calculated by {@link dk.camelot64.kickc.passes.Pass3LoopDepthAnalysis}. */
   private Integer depth;

   /**
    * Create a new natural loop.
    * The loop is not filled with all blocks from the start, but only holds the head & tail.
    *
    * @param head The head block, start of the loop.
    * @param tail The tail block, source of the back edge
    */
   public NaturalLoop(LabelRef head, LabelRef tail) {
      this.head = head;
      this.tails = new LinkedHashSet<>();
      tails.add(tail);
      this.blocks = null;
   }

   public LabelRef getHead() {
      return head;
   }

   public Set<LabelRef> getTails() {
      return tails;
   }

   public Set<LabelRef> getBlocks() {
      return blocks;
   }

   public void setBlocks(Set<LabelRef> blocks) {
      this.blocks = blocks;
   }

   @Override
   public String toString() {
      StringBuilder out = new StringBuilder();
      out.append("Loop head: ")
            .append(head)
            .append(" tails: ");
      for (LabelRef tail : tails) {
         out.append(tail).append(" ");
      }
      out.append("blocks: ");
      if (blocks != null) {
         for (LabelRef block : blocks) {
            out.append(block.toString()).append(" ");
         }
      } else {
         out.append("null");
      }
      if(depth!=null) {
         out.append(" depth: "+depth);
      }
      return out.toString();
   }

   /**
    * Determines if this loop contains another loop - ie. if the other loops blocks are all contained in this loops blocks.
    *
    * @param other The other loop
    * @return true if this loop contains the other loop
    */
   public boolean nests(NaturalLoop other) {
      for (LabelRef otherBlock : other.getBlocks()) {
         if (!blocks.contains(otherBlock)) {
            return false;
         }
      }
      return true;
   }

   /**
    * Add more tails to the loop
    * @param tails The tails to add
    */
   public void addTails(Set<LabelRef> tails) {
      this.tails.addAll(tails);
   }

   /**
    * Add more blocks to the loop
    * @param blocks The blocks to add
    */
   public void addBlocks(Set<LabelRef> blocks) {
      this.blocks.addAll(blocks);
   }

   public Integer getDepth() {
      return depth;
   }

   public void setDepth(Integer depth) {
      this.depth = depth;
   }

   @Override
   public boolean equals(Object o) {
      if (this == o) return true;
      if (o == null || getClass() != o.getClass()) return false;

      NaturalLoop that = (NaturalLoop) o;

      if (head != null ? !head.equals(that.head) : that.head != null) return false;
      if (tails != null ? !tails.equals(that.tails) : that.tails != null) return false;
      return blocks != null ? blocks.equals(that.blocks) : that.blocks == null;
   }

   @Override
   public int hashCode() {
      int result = head != null ? head.hashCode() : 0;
      result = 31 * result + (tails != null ? tails.hashCode() : 0);
      result = 31 * result + (blocks != null ? blocks.hashCode() : 0);
      return result;
   }

}
