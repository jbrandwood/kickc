package dk.camelot64.kickc.model.statements;

import dk.camelot64.kickc.model.Comment;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.operators.Operator;
import dk.camelot64.kickc.model.values.LValue;
import dk.camelot64.kickc.model.values.RValue;

import java.util.List;
import java.util.Objects;

/**
 * Single Static Assignment Form Statement.
 * Intermediate form used for compiler optimization.
 * <br>
 * <i> X<sub>i</sub> := Y<sub>j</sub> &lt;op&gt; Z<sub>k</sub> </i>
 * <br>
 * <i> lValue := rValue1 &lt;operator&gt; rValue2 </i>
 */
public class StatementAssignment extends StatementBase implements StatementLValue {

   /** The variable being assigned a value by the statement. */
   private LValue lValue;
   private RValue rValue1;
   private Operator operator;
   private RValue rValue2;

   /** This is the initial assignment of the lValue. */
   private boolean initialAssignment;

   public StatementAssignment(LValue lValue, RValue rValue2, boolean initialAssignment, StatementSource source, List<Comment> comments) {
      this(lValue, null, null, rValue2, initialAssignment, source, comments);
   }

   public StatementAssignment(LValue lValue, Operator operator, RValue rValue2, boolean initialAssignment, StatementSource source, List<Comment> comments) {
      this(lValue, null, operator, rValue2, initialAssignment, source, comments);
   }

   public StatementAssignment(LValue lValue, RValue rValue1, Operator operator, RValue rValue2, boolean initialAssignment, StatementSource source, List<Comment> comments) {
      super(source, comments);
      this.lValue = lValue;
      this.rValue1 = rValue1;
      this.operator = operator;
      this.rValue2 = rValue2;
      this.initialAssignment = initialAssignment;
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
   public boolean isInitialAssignment() {
      return initialAssignment;
   }

   public void setInitialAssignment(boolean initialAssignment) {
      this.initialAssignment = initialAssignment;
   }

   @Override
   public String toString(Program program, boolean aliveInfo) {
      return
            super.idxString() +
                  lValue.toString(program) + " = " +
                  (rValue1 == null ? "" : rValue1.toString(program) + " ") +
                  (operator == null ? "" : operator + " ") +
                  rValue2.toString(program) +
                  (aliveInfo ? super.aliveString(program) : "");
   }

   @Override
   public boolean equals(Object o) {
      if(this == o) return true;
      if(o == null || getClass() != o.getClass()) return false;
      if(!super.equals(o)) return false;
      StatementAssignment that = (StatementAssignment) o;
      return initialAssignment == that.initialAssignment &&
            Objects.equals(lValue, that.lValue) &&
            Objects.equals(rValue1, that.rValue1) &&
            Objects.equals(operator, that.operator) &&
            Objects.equals(rValue2, that.rValue2);
   }

   @Override
   public int hashCode() {
      return Objects.hash(super.hashCode(), lValue, rValue1, operator, rValue2, initialAssignment);
   }
}
