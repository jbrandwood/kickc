package dk.camelot64.kickc.model.statements;

import dk.camelot64.kickc.model.Comment;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.types.SymbolTypeProcedure;
import dk.camelot64.kickc.model.values.LValue;
import dk.camelot64.kickc.model.values.ProcedureRef;

import java.util.List;
import java.util.Objects;

/**
 * Call procedure finalization in SSA form.
 * <br>
 * lval = call func(params) are converted to callprepare func(params) / callexecute func() / lval=callfinalize func().
 * <br>
 * lvalue=callfinalize procedure </i>
 */
public class StatementCallFinalize extends StatementBase implements StatementLValue {

   /** The procedure called (if this is a call to a specific procedure). Null if this is a pointer-based call. */
   private ProcedureRef procedure;

   /** The type of the procedure. */
   private SymbolTypeProcedure procedureType;

   /** The calling convention to use. */
   private Procedure.CallingConvention callingConvention;

   /** The variable being assigned a value by the call. Can be null. */
   private LValue lValue;
   /** This is the initial assignment of the lValue. */
   private boolean initialAssignment;

   public StatementCallFinalize(LValue lValue, SymbolTypeProcedure procedureType, ProcedureRef procedure, Procedure.CallingConvention callingConvention, StatementSource source, List<Comment> comments) {
      super(source, comments);
      this.lValue = lValue;
      this.procedure = procedure;
      this.procedureType = procedureType;
      this.callingConvention = callingConvention;
   }

   public LValue getlValue() {
      return lValue;
   }

   public void setlValue(LValue lValue) {
      this.lValue = lValue;
   }

   public ProcedureRef getProcedure() {
      return procedure;
   }

   public void setProcedure(ProcedureRef procedure) {
      this.procedure = procedure;
   }

   public SymbolTypeProcedure getProcedureType() {
      return procedureType;
   }

   public Procedure.CallingConvention getCallingConvention() {
      return callingConvention;
   }

   @Override
   public boolean isInitialAssignment() {
      return initialAssignment;
   }

   @Override
   public void setInitialAssignment(boolean initialAssignment) {
      this.initialAssignment = initialAssignment;
   }

   @Override
   public String toString(Program program, boolean aliveInfo) {
      StringBuilder res = new StringBuilder();
      res.append(super.idxString());
      if(lValue != null) {
         res.append(lValue.toString(program));
         res.append(" = ");
      }
      res.append("callfinalize ");
      if(procedure != null) {
         res.append(procedure.getFullName()).append(" ");
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
      StatementCallFinalize that = (StatementCallFinalize) o;
      return Objects.equals(lValue, that.lValue) &&
            Objects.equals(procedure, that.procedure);
   }

   @Override
   public int hashCode() {
      return Objects.hash(super.hashCode(), lValue, procedure);
   }
}
