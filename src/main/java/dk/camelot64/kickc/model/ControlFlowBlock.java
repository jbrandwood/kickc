package dk.camelot64.kickc.model;

import dk.camelot64.kickc.model.statements.*;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.values.LabelRef;
import dk.camelot64.kickc.model.values.ScopeRef;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.ListIterator;

/**
 * A named/labelled sequence of SSA statements connected to other basic blocks.
 * The connections defines the control flow of the program.
 * The block only knows its own successors. To find predecessor blocks access to the entire graph is needed.
 */
public class ControlFlowBlock implements Graph.Block {

   /** The label representing the block. */
   private LabelRef label;

   /** The scope that the block is a part of. */
   private ScopeRef scope;

   /** The statements of the block. */
   private List<Statement> statements;

   /** The default successor that control flows to when exiting the block. */
   private LabelRef defaultSuccessor;

   /** The conditional successor of the block. If the last statement is a conditional jump this is the block that control flows to if the condition is met. */
   private LabelRef conditionalSuccessor;

   /** If the last statement of the block is a call this is the block containing the start of the called procedure. When the procedure returns control moves on to the default successor. */
   private LabelRef callSuccessor;

   /** The comments for the block. */
   private List<Comment> comments;

   public ControlFlowBlock(LabelRef label, ScopeRef scope) {
      this.label = label;
      this.scope = scope;
      this.statements = new ArrayList<>();
      this.defaultSuccessor = null;
      this.conditionalSuccessor = null;
      this.comments = new ArrayList<>();
   }

   public List<Comment> getComments() {
      return comments;
   }

   public void setComments(List<Comment> comments) {
      this.comments = comments;
   }

   public LabelRef getLabel() {
      return label;
   }

   public void setLabel(LabelRef label) {
      this.label = label;
   }

   public ScopeRef getScope() {
      return scope;
   }

   public void addStatement(Statement statement) {
      this.statements.add(statement);
   }

   /**
    * Add a statement just before the call statement.
    * <p>
    * Fails if there is no call statement
    *
    * @param newStatement The statement to add.
    */
   public void addStatementBeforeCall(Statement newStatement) {
      ListIterator<Statement> listIterator = statements.listIterator();
      while(listIterator.hasNext()) {
         Statement statement = listIterator.next();
         if(statement instanceof StatementCall) {
            listIterator.previous();
            listIterator.add(newStatement);
            return;
         }
      }
      throw new InternalError("No call statement in block " + getLabel().getFullName());
   }

   /**
    * Adds a new statement after an existing predecessor statement
    * @param newStatement The new statement to add
    * @param predecessor The existing predecessor statement
    */
   public void addStatementAfter(Statement newStatement, Statement predecessor) {
      ListIterator<Statement> listIterator = statements.listIterator();
      while(listIterator.hasNext()) {
         Statement statement = listIterator.next();
         if(statement.equals(predecessor)) {
            listIterator.previous();
            listIterator.add(newStatement);
            return;
         }
      }
      throw new InternalError("Predecessor not found in block " +getLabel().getFullName() + " predecessor: "+ predecessor.toString());
   }

   public LabelRef getDefaultSuccessor() {
      return defaultSuccessor;
   }

   public void setDefaultSuccessor(LabelRef defaultSuccessor) {
      this.defaultSuccessor = defaultSuccessor;
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

   /**
    * Is the block the exit of a procedure, ie. the last block of code of the the procedure
    *
    * @param program
    * @return true if this is the exit of a procedure
    */
   public boolean isProcedureExit(Program program) {
      return getLabel().isProcExit();
   }


   public String toString(Program program, Graph graph) {
      StringBuffer out = new StringBuffer();

      if(program.isProcedureEntry(this)) {
         Procedure procedure = (Procedure) program.getScope().getScope(scope);
         out.append("\n");
         out.append(procedure.toString(program)+"\n");
      }

      out.append(label.getFullName() + ":");
      out.append(" scope:[" + this.scope.getFullName() + "] ");
      out.append(" from");
      if(graph != null) {
         List<Graph.Block> predecessors = graph.getPredecessors(this);
         if(predecessors.size() > 0) {
            for(Graph.Block predecessor : predecessors) {
               out.append(" " + predecessor.getLabel().getFullName());
            }
         }
      } else {
         out.append(" @UNKNOWN");
      }
      out.append("\n");
      for(Statement statement : statements) {
         if(program.getLog().isVerboseComments()) {
            for(Comment comment : statement.getComments()) {
               out.append("  //" + comment.getComment() + "\n");
            }
         }
         if(program.getLog().isVerboseSsaSourceCode()) {
            if(statement.getSource()!=null && statement.getSource().getCode()!=null)
               out.append("  // " + statement.getSource().getCode()).append("\n");
         }
         out.append("  " + statement.toString(program, program.getLog().isVerboseLiveRanges()) + "\n");
      }
      if(defaultSuccessor != null) {
         out.append("  to:");
         out.append(defaultSuccessor.getFullName());
         out.append("\n");
      }
      return out.toString();
   }

   @Override
   public boolean equals(Object o) {
      if(this == o) return true;
      if(o == null || getClass() != o.getClass()) return false;
      ControlFlowBlock that = (ControlFlowBlock) o;
      if(!label.equals(that.label)) return false;
      if(statements != null ? !statements.equals(that.statements) : that.statements != null) return false;
      if(defaultSuccessor != null ? !defaultSuccessor.equals(that.defaultSuccessor) : that.defaultSuccessor != null)
         return false;
      if(conditionalSuccessor != null ? !conditionalSuccessor.equals(that.conditionalSuccessor) : that.conditionalSuccessor != null)
         return false;
      return callSuccessor != null ? callSuccessor.equals(that.callSuccessor) : that.callSuccessor == null;
   }

   @Override
   public int hashCode() {
      int result = label.hashCode();
      result = 31 * result + statements.size();
      result = 31 * result + (defaultSuccessor != null ? defaultSuccessor.hashCode() : 0);
      result = 31 * result + (conditionalSuccessor != null ? conditionalSuccessor.hashCode() : 0);
      result = 31 * result + (callSuccessor != null ? callSuccessor.hashCode() : 0);
      return result;
   }

   /**
    * Get the phi block for the block. If the phi block has not yet been created it is created.
    *
    * @return
    */
   public StatementPhiBlock getPhiBlock() {
      StatementPhiBlock phiBlock = null;
      if(statements.size() > 0 && statements.get(0) instanceof StatementPhiBlock) {
         phiBlock = (StatementPhiBlock) statements.get(0);
      }
      if(phiBlock == null) {
         phiBlock = new StatementPhiBlock(new ArrayList<>());
         statements.add(0, phiBlock);
      }
      return phiBlock;
   }

   public boolean hasPhiBlock() {
      if(statements.size() > 0) {
         if(statements.get(0) instanceof StatementPhiBlock) {
            return true;
         }
      }
      return false;
   }


}
