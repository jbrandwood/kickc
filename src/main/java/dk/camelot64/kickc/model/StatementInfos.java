package dk.camelot64.kickc.model;

import java.util.Map;

/** Cached information about statements (which block they belong to, statement from idx, ...) */
public class StatementInfos {

   /** The control flow graph. */
   private ControlFlowGraph graph;

   /** Maps statement index to block label. */
   private Map<Integer, LabelRef> stmtBlocks;

   /** Maps statement index to statement. */
   private Map<Integer, Statement> stmtIdx;

   public StatementInfos(Program program, Map<Integer, LabelRef> stmtBlocks, Map<Integer, Statement> stmtIdx) {
      this.graph = program.getGraph();
      this.stmtBlocks = stmtBlocks;
      this.stmtIdx = stmtIdx;
   }

   /**
    * Get the label of the block containing a statement
    * @param stmtIdx The statement index
    * @return The block label
    */
   public LabelRef getBlockRef(Integer stmtIdx) {
      return stmtBlocks.get(stmtIdx);
   }

   /**
    * Get the label of the block containing a statement
    * @param stmt The statement
    * @return The block label
    */
   public LabelRef getBlockRef(Statement stmt) {
      return stmtBlocks.get(stmt.getIndex());
   }

   /**
    * Get the block containing a statement
    * @param stmt The statement
    * @return The containing block
    */
   public ControlFlowBlock getBlock(Statement stmt) {
      return graph.getBlock(getBlockRef(stmt));
   }

   /**
    * Get the block containing a statement
    * @param stmtIdx The statement index
    * @return The containing block
    */
   public ControlFlowBlock getBlock(Integer stmtIdx) {
      return graph.getBlock(getBlockRef(stmtIdx));
   }

   /**
    * Get statement from index
    * @param Statement index
    * @return The statement with the passed index
    */
   public Statement getStatement(int index) {
      return stmtIdx.get(index);
   }

}
