package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ProcedureCompilation;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.StatementSequence;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementJump;
import dk.camelot64.kickc.model.symbols.Label;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.values.LabelRef;

/**
 * Assert that all jump labels exist
 */
public class Pass1AssertJumpLabels extends Pass1Base {

   public Pass1AssertJumpLabels(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      for(Procedure procedure : getProgram().getScope().getAllProcedures(true)) {
         final ProcedureCompilation procedureCompilation = getProgram().getProcedureCompilation(procedure.getRef());
         StatementSequence statementSequence = procedureCompilation.getStatementSequence();
         for(Statement statement : statementSequence.getStatements()) {
            if(statement instanceof StatementJump) {
               LabelRef jumpLabel = ((StatementJump) statement).getDestination();
               Label label = getScope().getLabel(jumpLabel);
               if(label==null) {
                  throw new CompileError("goto label undefined '"+jumpLabel.getLocalName()+"'", statement);
               }
            }
         }
      }

      return false;
   }

}
