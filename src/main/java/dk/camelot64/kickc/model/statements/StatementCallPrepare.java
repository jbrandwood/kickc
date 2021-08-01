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
 * Call procedure preparation in SSA form.
 * <br>
 * lval = call func(params) are converted to callprepare func(params) / callexecute func() / lval=callfinalize func().
 * <br>
 * callprepare procedure param1 param2 param3 ... </i>
 */
public class StatementCallPrepare extends StatementBase {

   /** The procedure called (if this is a call to a specific procedure). Null if this is a pointer-based call. */
   private ProcedureRef procedure;

   /** The type of the procedure. */
   private SymbolTypeProcedure procedureType;

   /** The calling convention to use. */
   private Procedure.CallingConvention callingConvention;

   /** The parameter values passed to the procedure. */
   private List<RValue> parameters;

   public StatementCallPrepare(SymbolTypeProcedure procedureType, ProcedureRef procedure, List<RValue> parameters, Procedure.CallingConvention callingConvention, StatementSource source, List<Comment> comments) {
      super(source, comments);
      this.procedureType = procedureType;
      this.procedure = procedure;
      this.parameters = parameters;
      this.callingConvention = callingConvention;
   }

   public SymbolTypeProcedure getProcedureType() {
      return procedureType;
   }

   public ProcedureRef getProcedure() {
      return procedure;
   }

   public void setProcedure(ProcedureRef procedure) {
      this.procedure = procedure;
   }

   public List<RValue> getParameters() {
      return parameters;
   }

   public void setParameters(List<RValue> parameters) {
      this.parameters = parameters;
   }

   public int getNumParameters() {
      return parameters.size();
   }

   public RValue getParameter(int idx) {
      return parameters.get(idx);
   }

   public Procedure.CallingConvention getCallingConvention() {
      return callingConvention;
   }

   @Override
   public String toString(Program program, boolean aliveInfo) {
      StringBuilder res = new StringBuilder();
      res.append(super.idxString());
      res.append("callprepare ");
      if(procedure != null) {
         res.append(procedure.getFullName() + " ");
      }
      if(parameters != null) {
         for(RValue parameter : parameters) {
            res.append(parameter.toString(program) + " ");
         }
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
      StatementCallPrepare that = (StatementCallPrepare) o;
      return Objects.equals(procedure, that.procedure) &&
            Objects.equals(parameters, that.parameters);
   }

   @Override
   public int hashCode() {
      return Objects.hash(super.hashCode(), procedure, parameters);
   }
}
