package dk.camelot64.kickc.passes;


import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementInfos;
import dk.camelot64.kickc.model.values.LabelRef;

import java.util.LinkedHashMap;

/**
 * Identify the block for each statement.
 */
public class Pass3StatementInfos extends Pass2SsaOptimization {

   public Pass3StatementInfos(Program program) {
      super(program);
   }


   /**
    * Create map from statement index to block
    */
   @Override
   public boolean step() {
      LinkedHashMap<Integer, LabelRef> stmtBlocks = new LinkedHashMap<>();
      LinkedHashMap<Integer, Statement> stmtIdx = new LinkedHashMap<>();
      for(ControlFlowBlock block : getProgram().getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            stmtBlocks.put(statement.getIndex(), block.getLabel());
            stmtIdx.put(statement.getIndex(), statement);
         }
      }
      getProgram().setStatementInfos(new StatementInfos(getProgram(), stmtBlocks, stmtIdx));
      return false;
   }


}
