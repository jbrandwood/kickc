package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.statements.*;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.symbols.Scope;
import dk.camelot64.kickc.model.types.SymbolTypeInference;
import dk.camelot64.kickc.model.values.ProcedureRef;

import java.util.Stack;

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
      Stack<Scope> scopes = new Stack<>();
      ProgramScope programScope = getScope();
      scopes.add(programScope);
      for(Statement statement : getProgram().getStatementSequence().getStatements()) {
         if(statement instanceof StatementProcedureBegin) {
            StatementProcedureBegin procedureBegin = (StatementProcedureBegin) statement;
            ProcedureRef procedureRef = procedureBegin.getProcedure();
            Procedure procedure = programScope.getProcedure(procedureRef);
            scopes.push(procedure);
         } else if(statement instanceof StatementProcedureEnd) {
            scopes.pop();
         } else if(statement instanceof StatementAssignment) {
            StatementAssignment assignment = (StatementAssignment) statement;
            SymbolTypeInference.inferAssignmentLValue(getProgram(), assignment, false);
         } else if(statement instanceof StatementCall) {
            StatementCall call = (StatementCall) statement;
            String procedureName = call.getProcedureName();
            Procedure procedure = scopes.peek().getProcedure(procedureName);
            if(procedure == null) {
               throw new CompileError("Called procedure not found. " + call.toString(getProgram(), false));
            }
            call.setProcedure(procedure.getRef());
            if(procedure.getParameters().size() != call.getParameters().size()) {
               throw new CompileError("Wrong number of parameters in call. Expected " + procedure.getParameters().size() + ". " + statement.toString());
            }
            SymbolTypeInference.inferCallLValue(getProgram(), (StatementCall) statement, false);
         }
      }
      return false;
   }

}
