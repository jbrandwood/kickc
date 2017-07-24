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
      return toString(null);
   }

   @Override
   public String toString(ProgramScope scope) {
      return
            lValue.toString(scope) + " ← " +
                  (rValue1==null?"":rValue1.toString(scope)+" ") +
                  (operator==null?"":operator+" ") +
                  rValue2.toString(scope);
   }

   @Override
   public boolean equals(Object o) {
      if (this == o) return true;
      if (o == null || getClass() != o.getClass()) return false;

      StatementAssignment that = (StatementAssignment) o;

      if (!lValue.equals(that.lValue)) return false;
      if (rValue1 != null ? !rValue1.equals(that.rValue1) : that.rValue1 != null) return false;
      if (operator != null ? !operator.equals(that.operator) : that.operator != null) return false;
      return rValue2 != null ? rValue2.equals(that.rValue2) : that.rValue2 == null;
   }

   @Override
   public int hashCode() {
      int result = lValue.hashCode();
      result = 31 * result + (rValue1 != null ? rValue1.hashCode() : 0);
      result = 31 * result + (operator != null ? operator.hashCode() : 0);
      result = 31 * result + (rValue2 != null ? rValue2.hashCode() : 0);
      return result;
   }
}
