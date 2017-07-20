package dk.camelot64.kickc.icl;

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

   public void addPhiStatement(VariableVersion newVersion) {
      statements.add(0, new StatementPhi(newVersion.getRef()));
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
      return label.equals(that.label);
   }

   @Override
   public int hashCode() {
      return label.hashCode();
   }

   public boolean hasPhiStatements() {
      if(statements.size()>0) {
         if(statements.get(0) instanceof StatementPhi) {
            return true;
         }
      }
      return false;
   }

}
