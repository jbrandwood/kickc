package dk.camelot64.kickc.icl;

import dk.camelot64.kickc.passes.Pass1TypeInference;

/** A constant defined by a unary operator appied to another constant */
public class ConstantUnary implements ConstantValue {

   /** The operator, */
   private Operator operator;

   /** The constant operand. */
   private Constant operand;

   public ConstantUnary(Operator operator, Constant operand) {
      this.operator = operator;
      this.operand = operand;
   }

   public Operator getOperator() {
      return operator;
   }

   public Constant getOperand() {
      return operand;
   }

   @Override
   public SymbolType getType(ProgramScope scope) {
      return Pass1TypeInference.inferType(operator, operand.getType(scope));
   }

   @Override
   public boolean equals(Object o) {
      if (this == o) {
         return true;
      }
      if (o == null || getClass() != o.getClass()) {
         return false;
      }

      ConstantUnary that = (ConstantUnary) o;

      if (!operator.equals(that.operator)) {
         return false;
      }
      return operand.equals(that.operand);
   }

   @Override
   public int hashCode() {
      int result = operator.hashCode();
      result = 31 * result + operand.hashCode();
      return result;
   }

   @Override
   public String toString(Program program) {
      return operator.toString()+operand.toString(program);
   }

   @Override
   public String toString() {
      return toString(null);
   }


}
