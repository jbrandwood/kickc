package dk.camelot64.kickc.ssa;

/**
 * Single Static Assignment Form Statement.
 * Intermediate form used for compiler optimization.
 * <br>
 * <i> X<sub>i</sub> := Y<sub>j</sub> &lt;op&gt; Z<sub>k</sub> </i>
 * <br>
 * <i> lValue := rValue1 &lt;operator&gt; rValue2 </i>
 */
public class SSAStatementAssignment implements SSAStatement {

   /** The variable being assigned a value by the statement. */
   private SSALValue lValue;

   private SSARValue rValue1;
   private SSAOperator operator;
   private SSARValue rValue2;

   public SSAStatementAssignment(SSALValue lValue, SSARValue rValue2) {
      this.lValue = lValue;
      this.rValue1 = null;
      this.operator = null;
      this.rValue2 = rValue2;
   }

   public SSAStatementAssignment(SSALValue lValue, SSARValue rValue1, SSAOperator operator, SSARValue rValue2) {
      this.lValue = lValue;
      this.rValue1 = rValue1;
      this.operator = operator;
      this.rValue2 = rValue2;
   }

   public SSAStatementAssignment(SSALValue lValue, SSAOperator operator, SSARValue rValue2) {
      this.lValue = lValue;
      this.rValue1 = null;
      this.operator = operator;
      this.rValue2 = rValue2;
   }

   public SSALValue getlValue() {
      return lValue;
   }

   public SSARValue getRValue1() {
      return rValue1;
   }

   public SSAOperator getOperator() {
      return operator;
   }

   public SSARValue getRValue2() {
      return rValue2;
   }

   @Override
   public String toString() {
      return
               "  "+
                  lValue + " ← " +
                  (rValue1==null?"":rValue1+" ") +
                  (operator==null?"":operator+" ") +
                  rValue2 ;
   }
}
