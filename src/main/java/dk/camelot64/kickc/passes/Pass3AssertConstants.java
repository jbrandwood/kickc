package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAsm;
import dk.camelot64.kickc.model.statements.StatementKickAsm;
import dk.camelot64.kickc.model.values.*;

import java.util.List;
import java.util.Map;

/**
 * Asserts that some RValues have been resolved to Constants.
 * Checks:
 * - KickAssembler locations
 * - KickAssembler bytes
 * - KickAssembler cycles
 * - ASM referenced variables
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
            } else if(statement instanceof StatementAsm) {
               StatementAsm statementAsm = (StatementAsm) statement;
               Map<String, SymbolVariableRef> referenced = statementAsm.getReferenced();
               for(String label : referenced.keySet()) {
                  SymbolVariableRef symbolRef = referenced.get(label);
                  if(!(symbolRef instanceof ConstantRef)) {
                     throw new CompileError("Error! Inline ASM reference is not constant " + label, statement);
                  }
               }
            } else if(statement instanceof StatementKickAsm) {
               StatementKickAsm statementAsm = (StatementKickAsm) statement;
               List<SymbolRef> uses = statementAsm.getUses();
               for(SymbolRef use : uses) {
                  if(!(use instanceof ConstantRef)) {
                     throw new CompileError("Error! Inline KickAsm reference is not constant " + use, statement);
                  }
               }
            }
         }
      }
   }

}
