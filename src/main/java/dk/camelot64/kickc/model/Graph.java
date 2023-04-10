package dk.camelot64.kickc.model;

import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementPhiBlock;
import dk.camelot64.kickc.model.values.LabelRef;
import dk.camelot64.kickc.model.values.ScopeRef;

import java.util.*;

/**
 * A read-only control flow graph.
 */
public interface Graph {

   Block getBlock(LabelRef symbol);

   List<Block> getAllBlocks();

   void addBlock(Graph.Block block);

   default List<Statement> getAllStatements() {
      return getAllBlocks().stream().map(Block::getStatements).flatMap(Collection::stream).toList();
   }

   default List<Graph.Block> getPredecessors(Graph.Block block) {
      ArrayList<Block> predecessorBlocks = new ArrayList<>();
      for(Graph.Block other : getAllBlocks()) {
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
      predecessorBlocks.sort(Comparator.comparing(o -> o.getLabel().getFullName()));
      return predecessorBlocks;
   }

   /**
    * Get all blocks that are part of the execution of a specific scope. (mostly a procedure)
    *
    * @param scope The scope to find blocks for
    * @return All blocks that are part of the execution of the scope
    */
   default List<Graph.Block> getScopeBlocks(ScopeRef scope) {
      ArrayList<Graph.Block> scopeBlocks = new ArrayList<>();
      for(Graph.Block block : getAllBlocks()) {
         if(block.getScope().equals(scope)) {
            scopeBlocks.add(block);
         }
      }
      return scopeBlocks;
   }

   /**
    * Get a statement from its statement index
    *
    * @param statementIdx The statement index
    * @return The statement
    */
   default Statement getStatementByIndex(int statementIdx) {
      for (Statement statement : getAllStatements()) {
         if (statement.getIndex() != null && statementIdx == statement.getIndex()) {
            return statement;
         }
      }
      return null;
   }

   default Graph.Block getDefaultSuccessor(Graph.Block block) {
      if(block.getDefaultSuccessor() != null) {
         return getBlock(block.getDefaultSuccessor());
      } else {
         return null;
      }
   }

   default Graph.Block getCallSuccessor(Graph.Block block) {
      if(block.getCallSuccessor() != null) {
         return getBlock(block.getCallSuccessor());
      } else {
         return null;
      }
   }

   default Graph.Block getConditionalSuccessor(Graph.Block block) {
      if(block.getConditionalSuccessor() != null) {
         return getBlock(block.getConditionalSuccessor());
      } else {
         return null;
      }
   }

   default String toString(Program program) {
      StringBuffer out = new StringBuffer();
      for(Graph.Block block : getAllBlocks()) {
         out.append(block.toString(program, this));
      }
      return out.toString();
   }

   interface Block {

      LabelRef getLabel();

      ScopeRef getScope();

      List<Statement> getStatements();

      boolean hasPhiBlock();

      StatementPhiBlock getPhiBlock();

      LabelRef getDefaultSuccessor();

      LabelRef getConditionalSuccessor();

      LabelRef getCallSuccessor();

      /**
       * Get all successors of the block
       *
       * @return All successors
       */
      default Collection<LabelRef> getSuccessors() {
         List<LabelRef> successors = new ArrayList<>();
         if(getDefaultSuccessor() != null) {
            successors.add(getDefaultSuccessor());
         }
         if(getConditionalSuccessor() != null) {
            successors.add(getConditionalSuccessor());
         }
         if(getCallSuccessor() != null) {
            successors.add(getCallSuccessor());
         }
         return successors;
      }

      public List<Comment> getComments();

      void setComments(List<Comment> comments);

      void setDefaultSuccessor(LabelRef defaultSuccessor);

      void setConditionalSuccessor(LabelRef conditionalSuccessor);

      void setCallSuccessor(LabelRef callSuccessor);

      void addStatement(Statement statement);

      void addStatementAfter(Statement newStatement, Statement predecessor);

      void addStatementBeforeCall(Statement newStatement);

      String toString(Program program, Graph graph);
   }
}
