package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.*;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.symbols.Scope;
import dk.camelot64.kickc.model.types.SymbolTypeInference;

/**
 * Pass through the generated statements inferring types of unresolved variables.
 * Also updates procedure calls to point to the actual procedure called.
 */
public class PassNTypeInference extends Pass2SsaOptimization {

   public PassNTypeInference(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) statement;
               try {
                  SymbolTypeInference.inferAssignmentLValue(getProgram(), assignment, false);
               } catch(CompileError e) {
                  throw new CompileError(e.getMessage(), statement.getSource());
               }
            } else if(statement instanceof StatementPhiBlock) {
               for(StatementPhiBlock.PhiVariable phiVariable : ((StatementPhiBlock) statement).getPhiVariables()) {
                  try {
                     SymbolTypeInference.inferPhiVariable(getProgram(), phiVariable, false);
                  } catch(CompileError e) {
                     throw new CompileError(e.getMessage(), statement.getSource());
                  }
               }
            } else if(statement instanceof StatementCall) {
               SymbolTypeInference.inferCallLValue(getProgram(), (StatementCall) statement, false);
            } else if(statement instanceof StatementCallPointer) {
               SymbolTypeInference.inferCallPointerLValue(getProgram(), (StatementCallPointer) statement, false);
            }

         }
      }
      return false;
   }

}
