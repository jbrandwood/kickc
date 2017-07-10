package dk.camelot64.kickc.icl;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Map;

/** The control flow graph of the program.
 * The control flow  graph is a set of connected basic blocks. */
public class ControlFlowGraph {

   private Map<Symbol, ControlFlowBlock> blocks;

   private ControlFlowBlock firstBlock;
   private List<ControlFlowBlock> sequence;

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
         out.append(block.toString(this));
      }
      return out.toString();
   }

   public Collection<ControlFlowBlock> getAllBlocks() {
      return blocks.values();
   }

   /** Get the assignment of the passed variable.
    *
     * @param variable The variable to find the assignment for
    * @return The assignment. null if the variable is not assigned. The variable is assigned by a Phi-statement instead.
    */
   public StatementAssignment getAssignment(Variable variable) {
      if(variable instanceof VariableUnversioned) {
         throw new RuntimeException("Error attempting to get assignment of unversioned variable, which is not guaranteed to be unique "+variable);
      }
      for (ControlFlowBlock block : getAllBlocks()) {
         for (Statement statement : block.getStatements()) {
            if(statement instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) statement;
               if(assignment.getLValue().equals(variable)) {
                  return assignment;
               }
            }
         }
      }
      return null;
   }

   public ControlFlowBlock getDefaultSuccessor(ControlFlowBlock block) {
      if(block.getDefaultSuccessor()!=null) {
         return blocks.get(block.getDefaultSuccessor());
      } else {
         return null;
      }
   }

   public ControlFlowBlock getCallSuccessor(ControlFlowBlock block) {
      if(block.getCallSuccessor()!=null) {
         return blocks.get(block.getCallSuccessor());
      } else {
         return null;
      }
   }

   public ControlFlowBlock getConditionalSuccessor(ControlFlowBlock block) {
      if(block.getConditionalSuccessor()!=null) {
         return blocks.get(block.getConditionalSuccessor());
      } else {
         return null;
      }
   }


   public List<ControlFlowBlock> getPredecessors(ControlFlowBlock block) {
      ArrayList<ControlFlowBlock> predecessorBlocks = new ArrayList<>();
      for (ControlFlowBlock other : getAllBlocks()) {
         if(block.getLabel().equals(other.getDefaultSuccessor())) {
            predecessorBlocks.add(other);
         }
         if(block.getLabel().equals(other.getConditionalSuccessor())) {
            predecessorBlocks.add(other);
         }
         if(block.getLabel().equals(other.getCallSuccessor())) {
            predecessorBlocks.add(other);
         }
      }
      return predecessorBlocks;
   }

   public void setBlockSequence(List<ControlFlowBlock> sequence) {
      this.sequence = sequence;
   }

   public List<ControlFlowBlock> getBlockSequence() {
      return sequence;
   }

}
