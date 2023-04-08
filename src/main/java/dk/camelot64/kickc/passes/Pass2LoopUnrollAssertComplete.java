package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Graph;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementConditionalJump;

/**
 * Check that the unrolling of a loop was sucessfully completed.
 * This is done by checking that no conditional jumps exist marked as wasUnrolled.
 * Since unrolling requires the loop iteration count to be constant the conditionals must always be resolved to true or false and thus deleted or changed to jumps.
 */
public class Pass2LoopUnrollAssertComplete extends Pass2SsaOptimization {

   public Pass2LoopUnrollAssertComplete(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      for(var block : getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementConditionalJump) {
               if(((StatementConditionalJump) statement).isWasUnrolled()) {
                  throw new CompileError("Loop cannot be unrolled. Condition not resolvable to a constant true/false. ", statement);
               }
            }
         }
      }
      return false;
   }
}
