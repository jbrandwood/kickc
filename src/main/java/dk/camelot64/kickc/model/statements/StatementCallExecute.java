package dk.camelot64.kickc.model.statements;

import dk.camelot64.kickc.model.Comment;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.types.SymbolTypeProcedure;
import dk.camelot64.kickc.model.values.ProcedureRef;
import dk.camelot64.kickc.model.values.RValue;

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

   /** The procedure called (if this is a call to a specific procedure). Null if this is a pointer-based call. */
   private RValue procedure;

   /** The type of the procedure. */
   private SymbolTypeProcedure procedureType;

   /** The calling convention to use. */
   private Procedure.CallingConvention callingConvention;

   public StatementCallExecute(SymbolTypeProcedure procedureType, RValue procedure, Procedure.CallingConvention callingConvention, StatementSource source, List<Comment> comments) {
      super(source, comments);
      this.procedureType = procedureType;
      this.procedure = procedure;
      this.callingConvention = callingConvention;
   }

   public SymbolTypeProcedure getProcedureType() {
      return procedureType;
   }

   public ProcedureRef getProcedure() {
      if(procedure instanceof ProcedureRef)
         return (ProcedureRef) procedure;
      else
         return null;
   }

   public RValue getProcedureRVal() {
      return procedure;
   }

   public void setProcedure(ProcedureRef procedure) {
      this.procedure = procedure;
   }

   public void setProcedureRVal(RValue procedure) {
      this.procedure = procedure;
   }


   public Procedure.CallingConvention getCallingConvention() {
      return callingConvention;
   }

   @Override
   public String toString(Program program, boolean aliveInfo) {
      StringBuilder res = new StringBuilder();
      res.append(super.idxString());
      res.append("callexecute ");
      res.append(procedure.toString(null) + " ");
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
