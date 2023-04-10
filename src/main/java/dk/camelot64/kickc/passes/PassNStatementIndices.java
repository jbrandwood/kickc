package dk.camelot64.kickc.passes;

/**
 * Identify the alive intervals for all variables. Add the intervals to the ProgramScope.
 */

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Graph;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;

public class PassNStatementIndices extends Pass2SsaOptimization {

   public PassNStatementIndices(Program program) {
      super(program);
   }


   /**
    * Create index numbers for all statements in the control flow graph.
    */
   @Override
   public boolean step() {
      int currentIdx = 0;
      for(var statement : getProgram().getGraph().getAllStatements()) {
         statement.setIndex(currentIdx++);
      }
      return false;
   }

}
