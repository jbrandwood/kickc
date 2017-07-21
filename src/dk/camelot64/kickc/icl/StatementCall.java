package dk.camelot64.kickc.icl;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.List;

/**
 * Call procedure in SSA form.
 * <br>
 * <i> X<sub>i</sub> := call label param1 param2 param3 ... </i>
 */
public class StatementCall implements StatementLValue {

   /** The variable being assigned a value by the call. Can be null. */
   private LValue lValue;
   private String procedureName;
   private ProcedureRef procedure;
   private List<RValue> parameters;
   private boolean parametersByAssignment;

   public StatementCall(
         LValue lValue, String  procedureName, List<RValue> parameters) {
      this.lValue = lValue;
      this.procedureName = procedureName;
      this.parameters = parameters;
      this.parametersByAssignment = false;
   }

   @JsonCreator
   StatementCall(
         @JsonProperty("lValue") LValue lValue,
         @JsonProperty("procedureName") String procedureName,
         @JsonProperty("procedure") ProcedureRef procedure,
         @JsonProperty("parameters") List<RValue> parameters,
         @JsonProperty("parametersByAssignment") boolean parametersByAssignment) {
      this.lValue = lValue;
      this.procedureName = procedureName;
      this.procedure = procedure;
      this.parameters = parameters;
      this.parametersByAssignment = parametersByAssignment;
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

   @JsonIgnore
   public int getNumParameters() {
      return parameters.size();
   }

   public RValue getParameter(int idx) {
      return parameters.get(idx);
   }

   public boolean isParametersByAssignment() {
      return parametersByAssignment;
   }

   public void setParametersByAssignment(boolean parametersByAssignment) {
      this.parametersByAssignment = parametersByAssignment;
   }

   public void clearParameters() {
      this.parameters = null;
      this.parametersByAssignment = true;
   }

   @Override
   public String toString() {
      return getAsString();
   }

   @Override
   public String getAsTypedString(ProgramScope scope) {
      StringBuilder res = new StringBuilder();
      if(lValue!=null) {
         res.append(lValue.getAsTypedString(scope));
         res.append(" ← ");
      }
      res.append("call ");
      if(procedure!=null) {
         res.append(procedure.getFullName()+ " ");
      }  else {
         res.append(procedureName + " ");
      }
      if(parameters!=null) {
         for (RValue parameter : parameters) {
            res.append(parameter.getAsTypedString(scope) + " ");
         }
      }
      if(parametersByAssignment) {
         res.append("param-assignment");
      }
      return res.toString();
   }

   @Override
   public String getAsString() {
      StringBuilder res = new StringBuilder();
      if(lValue!=null) {
         res.append(lValue.getAsString());
         res.append(" ← ");
      }
      res.append("call ");
      if(procedure!=null) {
         res.append(procedure.getFullName()+ " ");
      }  else {
         res.append(procedureName + " ");
      }
      if(parameters!=null) {
         for (RValue parameter : parameters) {
            res.append(parameter.getAsString() + " ");
         }
      }
      if(parametersByAssignment) {
         res.append("param-assignment");
      }
      return res.toString();
   }

   @Override
   public boolean equals(Object o) {
      if (this == o) return true;
      if (o == null || getClass() != o.getClass()) return false;

      StatementCall that = (StatementCall) o;

      if (parametersByAssignment != that.parametersByAssignment) return false;
      if (lValue != null ? !lValue.equals(that.lValue) : that.lValue != null) return false;
      if (!procedureName.equals(that.procedureName)) return false;
      if (procedure != null ? !procedure.equals(that.procedure) : that.procedure != null) return false;
      return parameters != null ? parameters.equals(that.parameters) : that.parameters == null;
   }

   @Override
   public int hashCode() {
      int result = lValue != null ? lValue.hashCode() : 0;
      result = 31 * result + procedureName.hashCode();
      result = 31 * result + (procedure != null ? procedure.hashCode() : 0);
      result = 31 * result + (parameters != null ? parameters.hashCode() : 0);
      result = 31 * result + (parametersByAssignment ? 1 : 0);
      return result;
   }
}
