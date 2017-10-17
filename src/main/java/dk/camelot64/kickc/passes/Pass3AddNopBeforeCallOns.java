package dk.camelot64.kickc.passes;

/**
 * If a method starts with a call to another method (or it is empty) - add an initial NOP operation (empty phi block).
 * This ensures that the live range propagation can propagate from method out to caller properly.
 */

import dk.camelot64.kickc.model.*;

import java.util.List;

public class Pass3AddNopBeforeCallOns extends Pass2Base {

   public Pass3AddNopBeforeCallOns(Program program) {
      super(program);
   }

   /**
    * Create index numbers for all statements in the control flow graph.
    */
   public void generate() {
      for (ControlFlowBlock block : getProgram().getGraph().getAllBlocks()) {
         if (block.isProcedureEntry(getProgram())) {
            List<Statement> statements = block.getStatements();
            if (statements.size() == 0) {
               statements.add(0, new StatementPhiBlock());
               getLog().append("Adding NOP phi() at start of " + block.getLabel());
            } else {
               Statement firstStmt = statements.get(0);
               if (firstStmt instanceof StatementCall) {
                  statements.add(0, new StatementPhiBlock());
                  getLog().append("Adding NOP phi() at start of " + block.getLabel());
               }
            }
         }
      }
   }

}
