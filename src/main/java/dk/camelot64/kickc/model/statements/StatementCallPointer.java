package dk.camelot64.kickc.model.statements;

import dk.camelot64.kickc.model.Comment;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.values.LValue;
import dk.camelot64.kickc.model.values.ProcedureRef;
import dk.camelot64.kickc.model.values.RValue;

import java.util.List;
import java.util.Objects;

/**
 * Call of a procedure where the called procedure is not directly named, but the result of an expression.
 */
public class StatementCallPointer extends StatementBase implements StatementLValue {

   /** The variable being assigned a value by the call. Can be null. */
   private LValue lValue;
   /** The expression calculating the procedure being called. */
   private RValue procedure;
   /** The parameter values passed to the procedure. */
   private List<RValue> parameters;
   /** This is the initial assignment of the lValue. */
   private boolean initialAssignment;

   public StatementCallPointer(LValue lValue, RValue procedure, List<RValue> parameters, StatementSource source, List<Comment> comments) {
      super(null, source, comments);
      this.lValue = lValue;
      this.procedure = procedure;
      this.parameters = parameters;
   }

   public RValue getProcedure() {
      return procedure;
   }

   public void setProcedure(RValue procedure) {
      this.procedure = procedure;
   }

   public LValue getlValue() {
      return lValue;
   }

   public void setlValue(LValue lValue) {
      this.lValue = lValue;
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

   public void clearParameters() {
      this.parameters = null;
   }

   @Override
   public boolean isInitialAssignment() {
      return initialAssignment;
   }

   public void setInitialAssignment(boolean initialAssignment) {
      this.initialAssignment = initialAssignment;
   }

   @Override
   public String toString(Program program, boolean aliveInfo) {
      StringBuilder res = new StringBuilder();
      res.append(super.idxString());
      if(lValue != null) {
         res.append(lValue.toString(program));
         res.append(" ← ");
      }
      res.append("call ");
         res.append(procedure.toString(program) + " ");
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
      StatementCallPointer that = (StatementCallPointer) o;
      return Objects.equals(lValue, that.lValue) &&
            Objects.equals(procedure, that.procedure) &&
            Objects.equals(parameters, that.parameters);
   }

   @Override
   public int hashCode() {
      return Objects.hash(super.hashCode(), lValue, procedure, parameters);
   }
}
