package dk.camelot64.kickc.icl;

import java.util.ArrayList;
import java.util.List;

/** A named/labelled sequence of SSA statements connected to other basic blocks.
 * The connections defines the control flow of the program.
 * The block only knows its own successors. To find predecessor blocks access to the entire graph is needed.*/
public class ControlFlowBlock {

   private Label label;

   private List<Statement> statements;

   private Label defaultSuccessor;

   private Label conditionalSuccessor;

   private Label callSuccessor;

   public ControlFlowBlock(Label label) {
      this.label = label;
      this.statements = new ArrayList<>();
      this.defaultSuccessor = null;
      this.conditionalSuccessor = null;
   }

   public Label getLabel() {
      return label;
   }

   public void addStatement(Statement statement) {
      this.statements.add(statement);
   }

   public void setDefaultSuccessor(Label defaultSuccessor) {
      this.defaultSuccessor = defaultSuccessor;
   }

   public Label getDefaultSuccessor() {
      return defaultSuccessor;
   }

   public Label getConditionalSuccessor() {
      return conditionalSuccessor;
   }

   public void setConditionalSuccessor(Label conditionalSuccessor) {
      this.conditionalSuccessor = conditionalSuccessor;
   }

   public Label getCallSuccessor() {
      return callSuccessor;
   }

   public void setCallSuccessor(Label callSuccessor) {
      this.callSuccessor = callSuccessor;
   }

   public List<Statement> getStatements() {
      return statements;
   }

   public void addPhiStatement(VariableVersion newVersion) {
      statements.add(0, new StatementPhi(newVersion));
   }

   @Override
   public String toString() {
      return toString(null);
   }

   public String toString(ControlFlowGraph graph) {
      StringBuffer out = new StringBuffer();
      out.append(label.getLocalName() + ":" );
      out.append(" from");
      if(graph!=null) {
         List<ControlFlowBlock> predecessors = graph.getPredecessors(this);
         if(predecessors.size()>0) {
            for (ControlFlowBlock predecessor : predecessors) {
               out.append(" " + predecessor.getLabel().getLocalName());
            }
         }
      } else {
         out.append(" @UNKNOWN");
      }
      out.append("\n");
      for (Statement statement : statements) {
         out.append("  "+statement+"\n");
      }
      if(defaultSuccessor!=null) {
         out.append("  to:");
         out.append(defaultSuccessor.getLocalName());
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
