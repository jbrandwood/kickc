package dk.camelot64.kickc.icl;

/**
 * Intermediate Compiler Form Statement with a conditional jump.
 * Intermediate form used for compiler optimization.
 * <br>
 * <i> if ( Y<sub>j</sub> ) goto XX </i>
 * <br>
 * The condition may be a single boolean variable, or a comparison between two variables (==, &lt;&gt;, &lt;, &gt;, &lt;=, &gt;= )
 *
 */
public class StatementConditionalJump implements Statement {

   private RValue rValue1;
   private Operator operator;
   private RValue rValue2;
   private LabelRef destination;

   public StatementConditionalJump(RValue condition, LabelRef destination) {
      this.rValue1 = null;
      this.operator = null;
      this.rValue2 = condition;
      this.destination = destination;
   }

   public StatementConditionalJump(RValue rValue1, Operator operator, RValue rValue2, LabelRef destination) {
      this.rValue1 = rValue1;
      this.operator = operator;
      this.rValue2 = rValue2;
      this.destination = destination;
   }

   public RValue getRValue1() {
      return rValue1;
   }

   public Operator getOperator() {
      return operator;
   }

   public RValue getRValue2() {
      return rValue2;
   }

   public LabelRef getDestination() {
      return destination;
   }

   public void setRValue1(RValue rValue1) {
      this.rValue1 = rValue1;
   }

   public void setOperator(Operator operator) {
      this.operator = operator;
   }

   public void setRValue2(RValue rValue2) {
      this.rValue2 = rValue2;
   }

   public void setDestination(LabelRef destination) {
      this.destination = destination;
   }

   @Override
   public String toString() {
      return getAsString();
   }

   @Override
   public String getAsTypedString(ProgramScope scope) {
      StringBuilder out = new StringBuilder();
      out.append("if(");
      if(rValue1!=null) {
         out.append(rValue1.getAsTypedString(scope));
         out.append(operator.getOperator());
      }
      out.append(rValue2.getAsTypedString(scope));
      out.append(") goto ");
      out.append(destination.getFullName());
      return out.toString();
   }

   @Override
   public String getAsString() {
      StringBuilder out = new StringBuilder();
      out.append("if(");
      if(rValue1!=null) {
         out.append(rValue1.getAsString());
         out.append(operator.getOperator());
      }
      out.append(rValue2.getAsString());
      out.append(") goto ");
      out.append(destination.getFullName());
      return out.toString();
   }
}
