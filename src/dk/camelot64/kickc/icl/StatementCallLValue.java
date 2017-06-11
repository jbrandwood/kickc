package dk.camelot64.kickc.icl;

import java.util.List;

/**
 * Call procedure in SSA form.
 * <br>
 * <i> X<sub>i</sub> := call label param1 param2 param3 ... </i>
 */
public class StatementCallLValue implements StatementLValue {

   /** The variable being assigned a value by the call. */
   private LValue lValue;
   private String procedureName;
   private List<RValue> parameters;
   private Procedure procedure;

   public StatementCallLValue(LValue lValue, String  procedureName, List<RValue> parameters) {
      this.lValue = lValue;
      this.procedureName = procedureName;
      this.parameters = parameters;
   }

   public LValue getLValue() {
      return lValue;
   }

   public void setLValue(LValue lValue) {
      this.lValue = lValue;
   }

   public String getProcedureName() {
      return procedureName;
   }

   public Procedure getProcedure() {
      return procedure;
   }

   public void setProcedure(Procedure procedure) {
      this.procedure = procedure;
   }

   public List<RValue> getParameters() {
      return parameters;
   }

   public int getNumParameters() {
      return parameters.size();
   }

   public RValue getParameter(int idx) {
      return parameters.get(idx);
   }

   @Override
   public String toString() {
      StringBuilder res = new StringBuilder();
      res.append(lValue);
      res.append(" ← ");
      res.append("call ");
      if(procedure!=null) {
         res.append(procedure.getFullName()+ " ");
      }  else {
         res.append(procedureName + " ");
      }
      for (RValue parameter : parameters) {
         res.append(parameter+" ");
      }
      return res.toString();
   }

}
