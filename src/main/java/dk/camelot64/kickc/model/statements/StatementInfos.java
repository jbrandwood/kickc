package dk.camelot64.kickc.model.statements;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.ControlFlowGraph;
import dk.camelot64.kickc.model.values.LabelRef;
import dk.camelot64.kickc.model.Program;

import java.util.Map;

/** Cached information about statements (which block they belong to, statement from idx, ...) */
public class StatementInfos {

   /** The control flow graph. */
   private ControlFlowGraph graph;

   /** Maps statement index to block label. */
   private Map<Integer, ControlFlowBlock> stmtBlocks;

   /** Maps statement index to statement. */
   private Map<Integer, Statement> stmtIdx;

   public StatementInfos(Program program, Map<Integer, ControlFlowBlock> stmtBlocks, Map<Integer, Statement> stmtIdx) {
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
   public ControlFlowBlock getBlock(Statement stmt) {
      return stmtBlocks.get(stmt.getIndex());
   }

   /**
    * Get the block containing a statement
    *
    * @param stmtIdx The statement index
    * @return The containing block
    */
   public ControlFlowBlock getBlock(Integer stmtIdx) {
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
