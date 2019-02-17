package dk.camelot64.kickc.model.statements;

import dk.camelot64.kickc.model.Comment;
import dk.camelot64.kickc.model.values.ProcedureRef;
import dk.camelot64.kickc.model.Program;

import java.util.List;

/**
 * Procedure declaration in SSA
 */
public class StatementProcedureEnd extends StatementBase {

   private ProcedureRef procedure;

   public StatementProcedureEnd(ProcedureRef procedure, StatementSource source, List<Comment> comments) {
      super(null, source, comments);
      this.procedure = procedure;
   }

   public ProcedureRef getProcedure() {
      return procedure;
   }

   @Override
   public String toString(Program program, boolean aliveInfo) {
      return super.idxString() + "endproc // " + procedure.getFullName() + "()" + (aliveInfo ? super.aliveString(program) : "");
   }
}
