package dk.camelot64.kickc.model;

import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.values.LabelRef;

import java.util.Map;

/** Cached information about statements (which block they belong to, statement from idx, ...) */
public class StatementInfos {

   /** The control flow graph. */
   private Graph graph;

   /** Maps statement index to block. */
   private Map<Integer, Graph.Block> stmtBlocks;

   /** Maps statement index to statement. */
   private Map<Integer, Statement> stmtIdx;

   public StatementInfos(Program program, Map<Integer, Graph.Block> stmtBlocks, Map<Integer, Statement> stmtIdx) {
      this.graph = program.getGraph();
      this.stmtBlocks = stmtBlocks;
      this.stmtIdx = stmtIdx;
   }

   /**
    * Get the label of the block containing a statement
    *
    * @param stmtIdx The statement index
    * @return The block label
    */
   public LabelRef getBlockRef(Integer stmtIdx) {
      return stmtBlocks.get(stmtIdx).getLabel();
   }

   /**
    * Get the label of the block containing a statement
    *
    * @param stmt The statement
    * @return The block label
    */
   public LabelRef getBlockRef(Statement stmt) {
      return stmtBlocks.get(stmt.getIndex()).getLabel();
   }

   /**
    * Get the block containing a statement
    *
    * @param stmt The statement
    * @return The containing block
    */
   public Graph.Block getBlock(Statement stmt) {
      return stmtBlocks.get(stmt.getIndex());
   }

   /**
    * Get the block containing a statement
    *
    * @param stmtIdx The statement index
    * @return The containing block
    */
   public Graph.Block getBlock(Integer stmtIdx) {
      return graph.getBlock(getBlockRef(stmtIdx));
   }

   /**
    * Get statement from index
    *
    * @param index Statement index
    * @return The statement with the passed index
    */
   public Statement getStatement(int index) {
      return stmtIdx.get(index);
   }

}
