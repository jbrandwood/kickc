package dk.camelot64.kickc.icl;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.*;

/** The control flow graph of the program.
 * The control flow  graph is a set of connected basic blocks. */
public class ControlFlowGraph {

   private Map<LabelRef, ControlFlowBlock> blocks;
   private LabelRef firstBlockRef;

   /** Sequence of blocks used when generating ASM */
   private List<LabelRef> sequence;

   public ControlFlowGraph(Map<LabelRef, ControlFlowBlock> blocks, LabelRef firstBlockRef) {
      this.blocks = blocks;
      this.firstBlockRef = firstBlockRef;
   }

   @JsonCreator
   public ControlFlowGraph(
         @JsonProperty("blocks") Map<LabelRef, ControlFlowBlock> blocks,
         @JsonProperty("firstBlockRef") LabelRef firstBlockRef,
         @JsonProperty("sequence") List<LabelRef> sequence) {
      this.blocks = blocks;
      this.firstBlockRef = firstBlockRef;
      this.sequence = sequence;
   }

   public ControlFlowBlock getBlock(LabelRef symbol) {
      return blocks.get(symbol);
   }

   public void addBlock(ControlFlowBlock block) {
      blocks.put(block.getLabel(), block);
   }

   @JsonIgnore
   public ControlFlowBlock getFirstBlock() {
      return getBlock(firstBlockRef);
   }

   @JsonIgnore
   public Collection<ControlFlowBlock> getAllBlocks() {
      if(sequence!=null) {
         ArrayList<ControlFlowBlock> blocks = new ArrayList<>();
         for (LabelRef labelRef : sequence) {
            blocks.add(getBlock(labelRef));
         }
         return blocks;
      } else {
         return blocks.values();
      }
   }

   public void remove(LabelRef label) {
      blocks.remove(label);
   }

   /** Get the assignment of the passed variable.
    *
     * @param variable The variable to find the assignment for
    * @return The assignment. null if the variable is not assigned. The variable is assigned by a Phi-statement instead.
    */
   public StatementAssignment getAssignment(VariableRef variable) {
      for (ControlFlowBlock block : getAllBlocks()) {
         for (Statement statement : block.getStatements()) {
            if(statement instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) statement;
               if(assignment.getlValue().equals(variable)) {
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
      Collections.sort(predecessorBlocks, new Comparator<ControlFlowBlock>() {
         @Override
         public int compare(ControlFlowBlock o1, ControlFlowBlock o2) {
            return o1.getLabel().getFullName().compareTo(o2.getLabel().getFullName());
         }
      });
      return predecessorBlocks;
   }

   public List<LabelRef> getSequence() {
      return sequence;
   }

   public void setSequence(List<LabelRef> sequence) {
      this.sequence = sequence;
   }

   @JsonIgnore
   public ControlFlowBlock getMainBlock() {
      for (ControlFlowBlock block : getAllBlocks()) {
         LabelRef label = block.getLabel();
         if(label.getFullName().equals("main")) {
            return block;
         }
      }
      return null;
   }



   public ControlFlowBlock getBlockFromStatementIdx(int statementIdx) {
      for (ControlFlowBlock block : getAllBlocks()) {
         for (Statement statement : block.getStatements()) {
            if(statementIdx==statement.getIndex()) {
               return block;
            }
         }
      }
      return null;
   }

   @Override
   public String toString() {
      return toString(null);
   }

   public String toString(Program program) {
      StringBuffer out = new StringBuffer();
      for (ControlFlowBlock block : getAllBlocks()) {
         out.append(block.toString(program));
      }
      return out.toString();
   }

   @Override
   public boolean equals(Object o) {
      if (this == o) return true;
      if (o == null || getClass() != o.getClass()) return false;

      ControlFlowGraph that = (ControlFlowGraph) o;

      if (!blocks.equals(that.blocks)) return false;
      if (!firstBlockRef.equals(that.firstBlockRef)) return false;
      return sequence != null ? sequence.equals(that.sequence) : that.sequence == null;
   }

   @Override
   public int hashCode() {
      int result = blocks.hashCode();
      result = 31 * result + firstBlockRef.hashCode();
      result = 31 * result + (sequence != null ? sequence.hashCode() : 0);
      return result;
   }

}
