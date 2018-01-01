package dk.camelot64.kickc.model;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * Intermediate Compiler Form Statement with a conditional jump.
 * Intermediate form used for compiler optimization.
 * <br>
 * <i> if ( Y<sub>j</sub> ) goto XX </i>
 * <br>
 * The condition may be a single boolean variable, or a comparison between two variables (==, &lt;&gt;, &lt;, &gt;, &lt;=, &gt;= )
 */
public class StatementConditionalJump extends StatementBase {

   private RValue rValue1;
   private Operator operator;
   private RValue rValue2;
   private LabelRef destination;

   public StatementConditionalJump(RValue condition, LabelRef destination) {
      super(null);
      this.rValue1 = null;
      this.operator = null;
      this.rValue2 = condition;
      this.destination = destination;
   }

   public StatementConditionalJump(
         RValue rValue1,
         Operator operator,
         RValue rValue2,
         LabelRef destination) {
      this(rValue1, operator, rValue2, destination, null);
   }

   @JsonCreator
   public StatementConditionalJump(
         @JsonProperty("rValue1") RValue rValue1,
         @JsonProperty("operator") Operator operator,
         @JsonProperty("rValue2") RValue rValue2,
         @JsonProperty("destination") LabelRef destination,
         @JsonProperty("index") Integer index) {
      super(index);
      this.rValue1 = rValue1;
      this.operator = operator;
      this.rValue2 = rValue2;
      this.destination = destination;
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

   public LabelRef getDestination() {
      return destination;
   }

   public void setDestination(LabelRef destination) {
      this.destination = destination;
   }

   @Override
   public String toString(Program program, boolean aliveInfo) {
      StringBuilder out = new StringBuilder();
      out.append(super.idxString());
      out.append("if(");
      if(rValue1 != null) {
         out.append(rValue1.toString(program));
         out.append(operator.getOperator());
      }
      out.append(rValue2.toString(program));
      out.append(") goto ");
      out.append(destination.getFullName());
      if(aliveInfo) {
         out.append(super.aliveString(program));
      }
      return out.toString();
   }

   @Override
   public boolean equals(Object o) {
      if(this == o) return true;
      if(o == null || getClass() != o.getClass()) return false;
      if(!super.equals(o)) return false;

      StatementConditionalJump that = (StatementConditionalJump) o;

      if(rValue1 != null ? !rValue1.equals(that.rValue1) : that.rValue1 != null) return false;
      if(operator != null ? !operator.equals(that.operator) : that.operator != null) return false;
      if(rValue2 != null ? !rValue2.equals(that.rValue2) : that.rValue2 != null) return false;
      return destination.equals(that.destination);
   }

   @Override
   public int hashCode() {
      int result = super.hashCode();
      result = 31 * result + (rValue1 != null ? rValue1.hashCode() : 0);
      result = 31 * result + (operator != null ? operator.hashCode() : 0);
      result = 31 * result + (rValue2 != null ? rValue2.hashCode() : 0);
      result = 31 * result + destination.hashCode();
      return result;
   }
}
