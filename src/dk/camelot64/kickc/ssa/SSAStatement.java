package dk.camelot64.kickc.ssa;

/**
 * Single Static Assignment Form Statement.
 * Intermediate form used for compiler optimization.
 * <br>
 * <i> X<sub>i</sub> := Y<sub>j</sub> &lt;op&gt; Z<sub>k</sub> </i>
 * <br>
 * <i> lValue := rValue1 &lt;operator&gt; rValue2 </i>
 */
public class SSAStatement implements SSAFragment {

   private SSALValue lValue;
   private SSARValue rValue1;
   private SSAOperator operator;
   private SSARValue rValue2;

   public SSAStatement(SSALValue lValue, SSARValue rValue1, SSAOperator operator, SSARValue rValue2) {
      this.lValue = lValue;
      this.rValue1 = rValue1;
      this.operator = operator;
      this.rValue2 = rValue2;
   }

   public SSAStatement(SSALValue lValue, SSAOperator operator, SSARValue rValue2) {
      this.lValue = lValue;
      this.rValue1 = null;
      this.operator = operator;
      this.rValue2 = rValue2;
   }

   public SSALValue getlValue() {
      return lValue;
   }

   public SSARValue getrValue1() {
      return rValue1;
   }

   public SSAOperator getOperator() {
      return operator;
   }

   public SSARValue getrValue2() {
      return rValue2;
   }

   @Override
   public String toString() {
      return lValue + " := " + (rValue1==null?"":rValue1) + " " + operator + " " + rValue2 ;
   }
}
