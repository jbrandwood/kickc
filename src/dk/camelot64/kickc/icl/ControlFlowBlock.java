package dk.camelot64.kickc.icl;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.ArrayList;
import java.util.List;

/** A named/labelled sequence of SSA statements connected to other basic blocks.
 * The connections defines the control flow of the program.
 * The block only knows its own successors. To find predecessor blocks access to the entire graph is needed.*/
public class ControlFlowBlock {

   private LabelRef label;

   private List<Statement> statements;

   private LabelRef defaultSuccessor;

   private LabelRef conditionalSuccessor;

   private LabelRef callSuccessor;

   public ControlFlowBlock(LabelRef label) {
      this.label = label;
      this.statements = new ArrayList<>();
      this.defaultSuccessor = null;
      this.conditionalSuccessor = null;
   }

   @JsonCreator
   public ControlFlowBlock(
         @JsonProperty("label") LabelRef label,
         @JsonProperty("statements") List<Statement> statements,
         @JsonProperty("defaultSuccessor") LabelRef defaultSuccessor,
         @JsonProperty("conditionalSuccessor") LabelRef conditionalSuccessor,
         @JsonProperty("callSuccessor") LabelRef callSuccessor) {
      this.label = label;
      this.statements = statements;
      this.defaultSuccessor = defaultSuccessor;
      this.conditionalSuccessor = conditionalSuccessor;
      this.callSuccessor = callSuccessor;
   }

   public LabelRef getLabel() {
      return label;
   }

   public void addStatement(Statement statement) {
      this.statements.add(statement);
   }

   public void setDefaultSuccessor(LabelRef defaultSuccessor) {
      this.defaultSuccessor = defaultSuccessor;
   }

   public LabelRef getDefaultSuccessor() {
      return defaultSuccessor;
   }

   public LabelRef getConditionalSuccessor() {
      return conditionalSuccessor;
   }

   public void setConditionalSuccessor(LabelRef conditionalSuccessor) {
      this.conditionalSuccessor = conditionalSuccessor;
   }

   public LabelRef getCallSuccessor() {
      return callSuccessor;
   }

   public void setCallSuccessor(LabelRef callSuccessor) {
      this.callSuccessor = callSuccessor;
   }

   public List<Statement> getStatements() {
      return statements;
   }

   public String getAsTypedString(ControlFlowGraph graph, ProgramScope scope) {
      StringBuffer out = new StringBuffer();
      out.append(label.getFullName() + ":" );
      out.append(" from");
      if(graph!=null) {
         List<ControlFlowBlock> predecessors = graph.getPredecessors(this);
         if(predecessors.size()>0) {
            for (ControlFlowBlock predecessor : predecessors) {
               out.append(" " + predecessor.getLabel().getFullName());
            }
         }
      } else {
         out.append(" @UNKNOWN");
      }
      out.append("\n");
      for (Statement statement : statements) {
         out.append("  "+statement.getAsTypedString(scope)+"\n");
      }
      if(defaultSuccessor!=null) {
         out.append("  to:");
         out.append(defaultSuccessor.getFullName());
         out.append("\n");
      }
      return out.toString();
   }

   public String getAsString(ControlFlowGraph graph) {
      StringBuffer out = new StringBuffer();
      out.append(label.getFullName() + ":" );
      out.append(" from");
      if(graph!=null) {
         List<ControlFlowBlock> predecessors = graph.getPredecessors(this);
         if(predecessors.size()>0) {
            for (ControlFlowBlock predecessor : predecessors) {
               out.append(" " + predecessor.getLabel().getFullName());
            }
         }
      } else {
         out.append(" @UNKNOWN");
      }
      out.append("\n");
      for (Statement statement : statements) {
         out.append("  "+statement.getAsString()+"\n");
      }
      if(defaultSuccessor!=null) {
         out.append("  to:");
         out.append(defaultSuccessor.getFullName());
         out.append("\n");
      }
      return out.toString();
   }

   @Override
   public boolean equals(Object o) {
      if (this == o) return true;
      if (o == null || getClass() != o.getClass()) return false;

      ControlFlowBlock that = (ControlFlowBlock) o;

      if (!label.equals(that.label)) return false;
      if (statements != null ? !statements.equals(that.statements) : that.statements != null) return false;
      if (defaultSuccessor != null ? !defaultSuccessor.equals(that.defaultSuccessor) : that.defaultSuccessor != null)
         return false;
      if (conditionalSuccessor != null ? !conditionalSuccessor.equals(that.conditionalSuccessor) : that.conditionalSuccessor != null)
         return false;
      return callSuccessor != null ? callSuccessor.equals(that.callSuccessor) : that.callSuccessor == null;
   }

   @Override
   public int hashCode() {
      int result = label.hashCode();
      result = 31 * result + (statements != null ? statements.hashCode() : 0);
      result = 31 * result + (defaultSuccessor != null ? defaultSuccessor.hashCode() : 0);
      result = 31 * result + (conditionalSuccessor != null ? conditionalSuccessor.hashCode() : 0);
      result = 31 * result + (callSuccessor != null ? callSuccessor.hashCode() : 0);
      return result;
   }

   /**
    * Get the phi block for the block. If the phi block has not yet been created it is created.
    * @return
    */
   @JsonIgnore
   public StatementPhiBlock getPhiBlock() {
      StatementPhiBlock phiBlock = null;
      if(statements.size()>0 && statements.get(0) instanceof StatementPhiBlock) {
         phiBlock = (StatementPhiBlock) statements.get(0);
      }
      if(phiBlock==null) {
         phiBlock = new StatementPhiBlock();
         statements.add(0, phiBlock);
      }
      return phiBlock;
   }

   public boolean hasPhiBlock() {
      if(statements.size()>0) {
         if(statements.get(0) instanceof StatementPhiBlock) {
            return true;
         }
      }
      return false;
   }


}
