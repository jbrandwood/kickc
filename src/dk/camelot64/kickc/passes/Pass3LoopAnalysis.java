package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.CompileLog;
import dk.camelot64.kickc.icl.ControlFlowBlock;
import dk.camelot64.kickc.icl.LabelRef;
import dk.camelot64.kickc.icl.Program;

import java.util.*;

/**
 * Finds loops and nested loops in the control flow graph
 */
public class Pass3LoopAnalysis {

   private Program program;
   private CompileLog log;

   public Pass3LoopAnalysis(Program program, CompileLog log) {
      this.program = program;
      this.log = log;
   }

   public Program getProgram() {
      return program;
   }

   public CompileLog getLog() {
      return log;
   }

   public void detectLoops() {

      GraphDominators graphDominators = analyseDominators();


   }

   /**
    * Analyse the control flow graph to find dominators for all blocks.
    * <p>
    * Definition: d dom i if all paths from entry to node i include d
    * <p>
    * See http://www.cs.colostate.edu/~cs553/ClassNotes/lecture09-control-dominators.ppt.pdf
    *
    * @return The graph dominators
    */
   private GraphDominators analyseDominators() {
      GraphDominators graphDominators = new GraphDominators();

      // Initialize dominators: Dom[first]={first}, Dom[block]={all}
      LabelRef firstBlock = program.getGraph().getFirstBlock().getLabel();
      BlockDominators firstDominators = graphDominators.addDominators(firstBlock);
      firstDominators.add(firstBlock);
      List<LabelRef> allBlocks = new ArrayList<>();
      for (ControlFlowBlock block : program.getGraph().getAllBlocks()) {
         allBlocks.add(block.getLabel());
      }
      for (ControlFlowBlock block : program.getGraph().getAllBlocks()) {
         if (!block.getLabel().equals(firstBlock)) {
            BlockDominators blockDominators = graphDominators.addDominators(block.getLabel());
            blockDominators.addAll(allBlocks);
         }
      }

      // Iteratively refine dominators until they do not change
      // For all nodes:
      // Dom[n] = {n} UNION ( INTERSECT Dom[p] for all p that are predecessors of n)
      boolean change = false;
      do {
         change = false;
         for (ControlFlowBlock block : program.getGraph().getAllBlocks()) {
            if (!block.getLabel().equals(firstBlock)) {
               List<ControlFlowBlock> predecessors = program.getGraph().getPredecessors(block);
               BlockDominators newDominators = new BlockDominators();
               newDominators.addAll(allBlocks);
               for (ControlFlowBlock predecessor : predecessors) {
                  BlockDominators predecessorDominators = graphDominators.getDominators(predecessor.getLabel());
                  newDominators.intersect(predecessorDominators);
               }
               newDominators.add(block.getLabel());
               BlockDominators currentDominators = graphDominators.getDominators(block.getLabel());
               if (!currentDominators.equals(newDominators)) {
                  change = true;
                  graphDominators.setDominators(block.getLabel(), newDominators);
               }
            }
         }

      } while (change);

      return graphDominators;
   }


   public static class GraphDominators {

      /**
       * Maps block label to the dominators of the block.
       */
      Map<LabelRef, BlockDominators> blockDominators;

      public GraphDominators() {
         this.blockDominators = new LinkedHashMap<>();
      }

      /**
       * Get the dominators for a specific block.
       *
       * @param block Label of the block
       * @return The block dominators
       */
      public BlockDominators getDominators(LabelRef block) {
         return blockDominators.get(block);
      }

      /**
       * Creates dominators for a specific block
       *
       * @param block Label of the block
       * @return The newly created block dominators
       */
      public BlockDominators addDominators(LabelRef block) {
         BlockDominators blockDominators = new BlockDominators();
         this.blockDominators.put(block, blockDominators);
         return blockDominators;
      }


      /**
       * Set the dominators for a specific block
       *
       * @param block      The block
       * @param dominators The new dominators
       */
      public void setDominators(LabelRef block, BlockDominators dominators) {
         blockDominators.put(block, dominators);
      }
   }

   /**
    * The Dominators for a specific block.
    */
   public static class BlockDominators {

      /**
       * Set containing the labels of all blocks that are dominators of the block.
       */
      Set<LabelRef> dominators;

      public BlockDominators() {
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
         for (LabelRef dominator : dominators) {
            add(dominator);
         }

      }

      /**
       * Modifies this set of dominators to be the intersection between this set and the passed set.
       * Effectively removes all labels from this set that is not also present in the passed set.
       *
       * @param other The dominator set to intersect with
       */
      public void intersect(BlockDominators other) {
         Iterator<LabelRef> iterator = dominators.iterator();
         while (iterator.hasNext()) {
            LabelRef dominator = iterator.next();
            if (!other.contains(dominator)) {
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
      private boolean contains(LabelRef block) {
         return dominators.contains(block);
      }

      public Set<LabelRef> getDominators() {
         return dominators;
      }

      @Override
      public boolean equals(Object o) {
         if (this == o) return true;
         if (o == null || getClass() != o.getClass()) return false;

         BlockDominators that = (BlockDominators) o;

         return dominators != null ? dominators.equals(that.dominators) : that.dominators == null;
      }

      @Override
      public int hashCode() {
         return dominators != null ? dominators.hashCode() : 0;
      }
   }


}
