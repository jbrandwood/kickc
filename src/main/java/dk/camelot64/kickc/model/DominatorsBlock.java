package dk.camelot64.kickc.model;

import dk.camelot64.kickc.model.values.LabelRef;

import java.util.Collection;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;

/**
 * The Dominators for a specific block.
 * <p>
 * Definition: Block d dominates block i if all paths from entry to block i includes block d
 * <p>
 * See http://www.cs.colostate.edu/~cs553/ClassNotes/lecture09-control-dominators.ppt.pdf
 */
public class DominatorsBlock {

   /**
    * Set containing the labels of all blocks that are dominators of the block.
    */
   Set<LabelRef> dominators;

   public DominatorsBlock() {
      this.dominators = new HashSet<>();
   }

   /**
    * Add a single dominator
    *
    * @param dominator The dominator to add
    */
   public void add(LabelRef dominator) {
      dominators.add(dominator);
   }

   /**
    * Adds a bunch of dominators
    *
    * @param dominators The dominators to add
    */
   public void addAll(Collection<LabelRef> dominators) {
      for(LabelRef dominator : dominators) {
         add(dominator);
      }

   }

   /**
    * Modifies this set of dominators to be the intersection between this set and the passed set.
    * Effectively removes all labels from this set that is not also present in the passed set.
    *
    * @param other The dominator set to intersect with
    */
   public void intersect(DominatorsBlock other) {
      Iterator<LabelRef> iterator = dominators.iterator();
      while(iterator.hasNext()) {
         LabelRef dominator = iterator.next();
         if(!other.contains(dominator)) {
            iterator.remove();
         }
      }
   }

   /**
    * Determines if the dominator set contains a specific block
    *
    * @param block The block to look for
    * @return true if the dominator set contains the block
    */
   public boolean contains(LabelRef block) {
      return dominators.contains(block);
   }

   public Set<LabelRef> getDominators() {
      return dominators;
   }

   @Override
   public boolean equals(Object o) {
      if(this == o) return true;
      if(o == null || getClass() != o.getClass()) return false;

      DominatorsBlock that = (DominatorsBlock) o;

      return dominators != null ? dominators.equals(that.dominators) : that.dominators == null;
   }

   @Override
   public int hashCode() {
      return dominators != null ? dominators.hashCode() : 0;
   }

   @Override
   public String toString() {
      StringBuilder out = new StringBuilder();
      for(LabelRef dominator : dominators) {
         out.append(dominator);
         out.append(" ");
      }
      return out.toString();
   }
}
