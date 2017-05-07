package dk.camelot64.kickc.icl;

/**
 * Single Static Assignment Form Statement.
 * Intermediate form used for compiler optimization.
 * <br>
 * <i> X<sub>i</sub> := Y<sub>j</sub> &lt;op&gt; Z<sub>k</sub> </i>
 * <br>
 * <i> lValue := rValue1 &lt;operator&gt; rValue2 </i>
 */
public class StatementAssignment implements Statement {

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

   public StatementAssignment(LValue lValue, RValue rValue1, Operator operator, RValue rValue2) {
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

   public RValue getRValue1() {
      return rValue1;
   }

   public Operator getOperator() {
      return operator;
   }

   public RValue getRValue2() {
      return rValue2;
   }

   @Override
   public String toString() {
      return

                  lValue + " ← " +
                  (rValue1==null?"":rValue1+" ") +
                  (operator==null?"":operator+" ") +
                  rValue2 ;
   }
}
