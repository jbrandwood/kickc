package dk.camelot64.kickc.passes.calcs;


import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementInfos;

import java.util.LinkedHashMap;

/**
 * Identify the block for each statement.
 */
public class PassNCalcStatementInfos extends PassNCalcBase<StatementInfos> {

   public PassNCalcStatementInfos(Program program) {
      super(program);
   }


   /**
    * Create map from statement index to block
    */
   @Override
   public StatementInfos calculate() {
      LinkedHashMap<Integer, ControlFlowBlock> stmtBlocks = new LinkedHashMap<>();
      LinkedHashMap<Integer, Statement> stmtIdx = new LinkedHashMap<>();
      for(ControlFlowBlock block : getProgram().getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            stmtBlocks.put(statement.getIndex(), block);
            stmtIdx.put(statement.getIndex(), statement);
         }
      }
      return new StatementInfos(getProgram(), stmtBlocks, stmtIdx);
   }


}
