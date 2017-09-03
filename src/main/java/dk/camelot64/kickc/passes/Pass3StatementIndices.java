package dk.camelot64.kickc.passes;

/**
 * Identify the alive intervals for all variables. Add the intervals to the ProgramScope.
 */

import dk.camelot64.kickc.icl.*;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class Pass3StatementIndices extends Pass2Base {

   public Pass3StatementIndices(Program program) {
      super(program);
   }

   /**
    * Create index numbers for all statements in the control flow graph.
    */
   public void generateStatementIndices() {
      int currentIdx = 0;
      for (ControlFlowBlock block : getProgram().getGraph().getAllBlocks()) {
         for (Statement statement : block.getStatements()) {
            statement.setIndex(currentIdx++);
         }
      }
   }


}
