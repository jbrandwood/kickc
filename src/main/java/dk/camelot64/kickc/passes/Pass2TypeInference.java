package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.statements.StatementCall;
import dk.camelot64.kickc.model.types.SymbolTypeInference;

/**
 * Pass through the all statements (re-)inferring types of variables.
 */
public class Pass2TypeInference extends Pass2SsaOptimization {

   public Pass2TypeInference(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      for(ControlFlowBlock block : getProgram().getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementAssignment) {
               SymbolTypeInference.inferAssignmentLValue(getProgram(), (StatementAssignment) statement, true);
            } else if(statement instanceof StatementCall) {
               SymbolTypeInference.inferCallLValue(getProgram(), (StatementCall) statement, true);
            }
         }
      }
      return false;
   }

}
