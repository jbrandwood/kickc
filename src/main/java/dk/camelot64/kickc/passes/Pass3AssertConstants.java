package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementKickAsm;
import dk.camelot64.kickc.model.values.ConstantValue;
import dk.camelot64.kickc.model.values.RValue;

/**
 * Asserts that some RValues have been resolved to Constants.
 * Checks:
 * - KickAssembler locations
 */
public class Pass3AssertConstants extends Pass2SsaAssertion {

   public Pass3AssertConstants(Program program) {
      super(program);
   }

   @Override
   public void check() throws AssertionFailed {
      for(ControlFlowBlock block : getProgram().getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementKickAsm) {
               RValue location = ((StatementKickAsm) statement).getLocation();
               if(location != null && !(location instanceof ConstantValue)) {
                  throw new CompileError("Error! KickAssembler location is not constant " + location.toString(), statement);
               }
               RValue bytes = ((StatementKickAsm) statement).getBytes();
               if(bytes != null && !(bytes instanceof ConstantValue)) {
                  throw new CompileError("Error! KickAssembler bytes is not constant " + bytes.toString(), statement);
               }
               RValue cycles = ((StatementKickAsm) statement).getCycles();
               if(cycles!= null && !(cycles instanceof ConstantValue)) {
                  throw new CompileError("Error! KickAssembler cycles is not constant " + cycles.toString(), statement);
               }
            }
         }
      }
   }

}
