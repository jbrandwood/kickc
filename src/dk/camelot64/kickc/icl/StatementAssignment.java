package dk.camelot64.kickc.icl;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonPropertyOrder;

/**
 * Single Static Assignment Form Statement.
 * Intermediate form used for compiler optimization.
 * <br>
 * <i> X<sub>i</sub> := Y<sub>j</sub> &lt;op&gt; Z<sub>k</sub> </i>
 * <br>
 * <i> lValue := rValue1 &lt;operator&gt; rValue2 </i>
 */
@JsonPropertyOrder({"lValue", "rValue1", "operator", "rValue2"})
public class StatementAssignment implements StatementLValue {

   /** The variable being assigned a value by the statement. */
   private LValue lValue;
   private RValue rValue1;
   private Operator operator;
   private RValue rValue2;

   public StatementAssignment(LValue lValue, RValue rValue2) {
      this.lValue = lValue;
      this.rValue1 = null;
      this.operator = null;
      this.rValue2 = rValue2;
   }

   public StatementAssignment(Variable lValue, Variable rValue2) {
      this(lValue.getRef(), rValue2.getRef());
   }

   public StatementAssignment(Variable lValue, RValue rValue2) {
      this(lValue.getRef(), rValue2);
   }

   @JsonCreator
   public StatementAssignment(
         @JsonProperty("lValue1") LValue lValue,
         @JsonProperty("rValue1") RValue rValue1,
         @JsonProperty("operator") Operator operator,
         @JsonProperty("rValue2") RValue rValue2) {
      this.lValue = lValue;
      this.rValue1 = rValue1;
      this.operator = operator;
      this.rValue2 = rValue2;
   }

   public StatementAssignment(LValue lValue, Operator operator, RValue rValue2) {
      this.lValue = lValue;
      this.rValue1 = null;
      this.operator = operator;
      this.rValue2 = rValue2;
   }

   public LValue getlValue() {
      return lValue;
   }

   public void setlValue(LValue lValue) {
      this.lValue = lValue;
   }

   public RValue getrValue1() {
      return rValue1;
   }

   public void setrValue1(RValue rValue1) {
      this.rValue1 = rValue1;
   }

   public Operator getOperator() {
      return operator;
   }

   public void setOperator(Operator operator) {
      this.operator = operator;
   }

   public RValue getrValue2() {
      return rValue2;
   }

   public void setrValue2(RValue rValue2) {
      this.rValue2 = rValue2;
   }

   @Override
   public String toString() {
      return getAsString();
   }

   @Override
   public String getAsTypedString(ProgramScope scope) {
      return
            lValue.getAsTypedString(scope) + " ← " +
                  (rValue1==null?"":rValue1.getAsTypedString(scope)+" ") +
                  (operator==null?"":operator+" ") +
                  rValue2 .getAsTypedString(scope);
   }

   @Override
   public String getAsString() {
      return
            lValue.getAsString() + " ← " +
                  (rValue1==null?"":rValue1.getAsString()+" ") +
                  (operator==null?"":operator+" ") +
                  rValue2.getAsString() ;
   }

}
