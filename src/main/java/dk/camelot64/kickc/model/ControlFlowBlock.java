package dk.camelot64.kickc.model;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.ListIterator;

/**
 * A named/labelled sequence of SSA statements connected to other basic blocks.
 * The connections defines the control flow of the program.
 * The block only knows its own successors. To find predecessor blocks access to the entire graph is needed.
 */
public class ControlFlowBlock {

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

   public ControlFlowBlock(LabelRef label, ScopeRef scope) {
      this.label = label;
      this.scope = scope;
      this.statements = new ArrayList<>();
      this.defaultSuccessor = null;
      this.conditionalSuccessor = null;
   }

   public ControlFlowBlock(
         LabelRef label,
         ScopeRef scope,
         List<Statement> statements,
         LabelRef defaultSuccessor,
         LabelRef conditionalSuccessor,
         LabelRef callSuccessor) {
      this.label = label;
      this.scope = scope;
      this.statements = statements;
      this.defaultSuccessor = defaultSuccessor;
      this.conditionalSuccessor = conditionalSuccessor;
      this.callSuccessor = callSuccessor;
   }

   public LabelRef getLabel() {
      return label;
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
      throw new RuntimeException("No call statement in block " + getLabel().getFullName());
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
    * Is the block the entry of a procedure, ie. the first block of the code of the procedure.
    *
    * @return true if this is the entry of a procedure
    */
   public boolean isProcedureEntry(Program program) {
      Symbol symbol = program.getScope().getSymbol(getLabel());
      return (symbol instanceof Procedure);
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


   public String toString(Program program) {
      ControlFlowGraph graph = program.getGraph();
      StringBuffer out = new StringBuffer();
      out.append(label.getFullName() + ":");
      out.append(" scope:[" + scope.getFullName() + "] ");
      out.append(" from");
      if(graph != null) {
         List<ControlFlowBlock> predecessors = graph.getPredecessors(this);
         if(predecessors.size() > 0) {
            for(ControlFlowBlock predecessor : predecessors) {
               out.append(" " + predecessor.getLabel().getFullName());
            }
         }
      } else {
         out.append(" @UNKNOWN");
      }
      out.append("\n");
      for(Statement statement : statements) {
         out.append("  " + statement.toString(program, true) + "\n");
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
      result = 31 * result + (statements != null ? statements.hashCode() : 0);
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
         phiBlock = new StatementPhiBlock();
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


   /**
    * Get all successors of the block
    *
    * @return All successors
    */
   public Collection<LabelRef> getSuccessors() {
      List<LabelRef> successors = new ArrayList<>();
      if(defaultSuccessor != null) {
         successors.add(defaultSuccessor);
      }
      if(conditionalSuccessor != null) {
         successors.add(conditionalSuccessor);
      }
      if(callSuccessor != null) {
         successors.add(callSuccessor);
      }
      return successors;
   }

}
