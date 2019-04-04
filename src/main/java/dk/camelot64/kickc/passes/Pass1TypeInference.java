package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.statements.StatementCall;
import dk.camelot64.kickc.model.statements.StatementCallPointer;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.symbols.Scope;
import dk.camelot64.kickc.model.types.SymbolTypeInference;

/**
 * Pass through the generated statements inferring types of unresolved variables.
 * Also updates procedure calls to point to the actual procedure called.
 */
public class Pass1TypeInference extends Pass1Base {

   public Pass1TypeInference(Program program) {
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
            } else if(statement instanceof StatementCall) {
               StatementCall call = (StatementCall) statement;
               String procedureName = call.getProcedureName();
               Scope currentScope = getScope().getScope(block.getScope());
               Procedure procedure = currentScope.getProcedure(procedureName);
               if(procedure == null) {
                  throw new CompileError("Called procedure not found. " + call.toString(getProgram(), false), statement.getSource());
               }
               call.setProcedure(procedure.getRef());
               if(procedure.getParameters().size() != call.getParameters().size()) {
                  throw new CompileError("Wrong number of parameters in call. Expected " + procedure.getParameters().size() + ". " + statement.toString(), statement.getSource());
               }
               SymbolTypeInference.inferCallLValue(getProgram(), (StatementCall) statement, false);
            } else if(statement instanceof StatementCallPointer) {
               SymbolTypeInference.inferCallPointerLValue(getProgram(), (StatementCallPointer) statement, false);
            }

         }
      }
      return false;
   }

}
