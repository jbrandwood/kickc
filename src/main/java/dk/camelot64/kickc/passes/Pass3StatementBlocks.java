package dk.camelot64.kickc.passes;


import dk.camelot64.kickc.model.*;

import java.util.LinkedHashMap;

/**
 * Identify the block for each statement.
 */
public class Pass3StatementBlocks extends Pass2Base {

   public Pass3StatementBlocks(Program program) {
      super(program);
   }

   /**
    * Create map from statement index to block
    */
   public void generateStatementBlocks() {
      LinkedHashMap<Integer, LabelRef> stmtBlocks = new LinkedHashMap<>();
      for (ControlFlowBlock block : getProgram().getGraph().getAllBlocks()) {
         for (Statement statement : block.getStatements()) {
            stmtBlocks.put(statement.getIndex(), block.getLabel());
         }
      }
      getProgram().setStatementBlocks(new StatementBlocks(getProgram(), stmtBlocks));
   }


}
