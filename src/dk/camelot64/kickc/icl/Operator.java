package dk.camelot64.kickc.icl;

/** An Operator. The operation performed on the rvalues in a Statement. */
public class Operator {

   private String operator;

   public Operator(String operator) {
      this.operator = operator;
   }

   public String getOperator() {
      return operator;
   }

   @Override
   public String toString() {
      return operator ;
   }
}
