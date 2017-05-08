package dk.camelot64.kickc.icl;

import java.util.ArrayList;
import java.util.List;

/** A named/labelled sequence of SSA statements connected to other basic blocks.
 * The connections defines the control flow of the program. */
public class ControlFlowBlock {

   private Symbol label;

   private List<ControlFlowBlock> predecessors;

   private List<Statement> statements;

   private ControlFlowBlock defaultSuccessor;

   private ControlFlowBlock conditionalSuccessor;

   public ControlFlowBlock(Symbol label) {
      this.label = label;
      this.statements = new ArrayList<>();
      this.predecessors = new ArrayList<>();
      this.defaultSuccessor = null;
      this.conditionalSuccessor = null;
   }

   public Symbol getLabel() {
      return label;
   }

   public void addStatement(Statement statement) {
      this.statements.add(statement);
   }

   public void addPredecessor(ControlFlowBlock block) {
      this.predecessors.add(block);
   }

   public void setDefaultSuccessor(ControlFlowBlock defaultSuccessor) {
      this.defaultSuccessor = defaultSuccessor;
   }

   public ControlFlowBlock getDefaultSuccessor() {
      return defaultSuccessor;
   }

   public ControlFlowBlock getConditionalSuccessor() {
      return conditionalSuccessor;
   }

   public List<ControlFlowBlock> getPredecessors() {
      return predecessors;
   }

   public void setConditionalSuccessor(ControlFlowBlock conditionalSuccessor) {
      this.conditionalSuccessor = conditionalSuccessor;
   }

   public void removePredecessor(ControlFlowBlock block) {
      predecessors.remove(block);
   }

   public List<Statement> getStatements() {
      return statements;
   }

   public void addPhiStatement(Symbol newVersion) {
      statements.add(0, new StatementPhi(newVersion));
   }

   @Override
   public String toString() {
      StringBuffer out = new StringBuffer();
      out.append(label.getName() + ":" );
      out.append(" from");
      for (ControlFlowBlock predecessor : predecessors) {
         out.append(" "+predecessor.getLabel().getName());
      }
      out.append("\n");
      for (Statement statement : statements) {
         out.append("  "+statement+"\n");
      }
      out.append("  to:");
      if(defaultSuccessor!=null) {
         out.append(defaultSuccessor.getLabel().getName());
      }
      out.append("\n");
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

}
