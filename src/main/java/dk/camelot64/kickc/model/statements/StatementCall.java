package dk.camelot64.kickc.model.statements;

import dk.camelot64.kickc.model.Comment;
import dk.camelot64.kickc.model.values.ProcedureRef;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.values.LValue;
import dk.camelot64.kickc.model.values.RValue;

import java.util.List;

/**
 * Call procedure in SSA form.
 * <br>
 * <i> X<sub>i</sub> := call label param1 param2 param3 ... </i>
 */
public class StatementCall extends StatementBase implements StatementLValue {

   /**
    * The variable being assigned a value by the call. Can be null.
    */
   private LValue lValue;
   private String procedureName;
   private ProcedureRef procedure;
   private List<RValue> parameters;

   public StatementCall(LValue lValue, String procedureName, List<RValue> parameters, StatementSource source, List<Comment> comments) {
      super(null, source, comments);
      this.lValue = lValue;
      this.procedureName = procedureName;
      this.parameters = parameters;
   }

   public LValue getlValue() {
      return lValue;
   }

   public void setlValue(LValue lValue) {
      this.lValue = lValue;
   }

   public String getProcedureName() {
      return procedureName;
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

   public void clearParameters() {
      this.parameters = null;
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
      if(procedure != null) {
         res.append(procedure.getFullName() + " ");
      } else {
         res.append(procedureName + " ");
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

      StatementCall that = (StatementCall) o;

      if(lValue != null ? !lValue.equals(that.lValue) : that.lValue != null) return false;
      if(!procedureName.equals(that.procedureName)) return false;
      if(procedure != null ? !procedure.equals(that.procedure) : that.procedure != null) return false;
      return parameters != null ? parameters.equals(that.parameters) : that.parameters == null;
   }

   @Override
   public int hashCode() {
      int result = super.hashCode();
      result = 31 * result + (lValue != null ? lValue.hashCode() : 0);
      result = 31 * result + procedureName.hashCode();
      result = 31 * result + (procedure != null ? procedure.hashCode() : 0);
      result = 31 * result + (parameters != null ? parameters.hashCode() : 0);
      return result;
   }
}
