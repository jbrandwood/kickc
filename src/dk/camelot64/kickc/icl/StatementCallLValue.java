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
   private Label callLabel;
   private List<RValue> parameters;

   public StatementCallLValue(LValue lValue, Label callLabel, List<RValue> parameters) {
      this.lValue = lValue;
      this.callLabel = callLabel;
      this.parameters = parameters;
   }

   public LValue getLValue() {
      return lValue;
   }

   public void setLValue(LValue lValue) {
      this.lValue = lValue;
   }

   public Label getCallLabel() {
      return callLabel;
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
      res.append(callLabel+" ");
      for (RValue parameter : parameters) {
         res.append(parameter+" ");
      }
      return res.toString();
   }

}
