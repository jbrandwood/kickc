package dk.camelot64.kickc.model.statements;

import dk.camelot64.kickc.model.Comment;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.values.ProcedureRef;

import java.util.List;
import java.util.Objects;

/**
 * Call procedure execution in SSA form.
 * <br>
 * lval = call func(params) are converted to callprepare func(params) / callexecute func() / lval=callfinalize func().
 * <br>
 * callexecute procedure ... </i>
 */
public class StatementCallExecute extends StatementBase implements StatementCalling {

   /** The procedure called. */
   private ProcedureRef procedure;

   public StatementCallExecute(ProcedureRef procedure, StatementSource source, List<Comment> comments) {
      super(null, source, comments);
      this.procedure = procedure;
   }

   public ProcedureRef getProcedure() {
      return procedure;
   }

   public void setProcedure(ProcedureRef procedure) {
      this.procedure = procedure;
   }

   @Override
   public String toString(Program program, boolean aliveInfo) {
      StringBuilder res = new StringBuilder();
      res.append(super.idxString());
      res.append("callexecute ");
      if(procedure != null) {
         res.append(procedure.getFullName() + " ");
      }
      if(aliveInfo) {
         res.append(super.aliveString(program));
      }
      return res.toString();
   }

   @Override
   public boolean equals(Object o) {
      if(this == o) return true;
      if(o == null || getClass() != o.getClass()) return false;
      if(!super.equals(o)) return false;
      StatementCallExecute that = (StatementCallExecute) o;
      return Objects.equals(procedure, that.procedure);
   }

   @Override
   public int hashCode() {
      return Objects.hash(super.hashCode(), procedure);
   }
}
