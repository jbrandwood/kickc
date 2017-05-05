package dk.camelot64.kickc.ssa;

/** SSA Form Operator. The operation performed on the rvalues in an SSA Statement. */
public class SSAOperator {

   private String operator;

   public SSAOperator(String operator) {
      this.operator = operator;
   }

   @Override
   public String toString() {
      return operator ;
   }
}
