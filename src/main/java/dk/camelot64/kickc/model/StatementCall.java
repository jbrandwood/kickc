package dk.camelot64.kickc.model;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;

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
   private boolean parametersByAssignment;

   public StatementCall(LValue lValue, String procedureName, List<RValue> parameters) {
      super(null);
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
         @JsonProperty("parametersByAssignment") boolean parametersByAssignment,
         @JsonProperty("index") Integer index) {
      super(index);
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
      if(parametersByAssignment) {
         res.append("param-assignment");
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

      if(parametersByAssignment != that.parametersByAssignment) return false;
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
      result = 31 * result + (parametersByAssignment ? 1 : 0);
      return result;
   }
}
