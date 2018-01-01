package dk.camelot64.kickc.model;

/** A constant defined by a binary operator applied to two constants */
public class ConstantBinary implements ConstantValue {

   /** The left constant operand. */
   private ConstantValue left;

   /** The operator, */
   private Operator operator;

   /** The right constant operand. */
   private ConstantValue right;

   public ConstantBinary(ConstantValue left, Operator operator, ConstantValue right) {
      this.left = left;
      this.operator = operator;
      this.right = right;
   }

   public Operator getOperator() {
      return operator;
   }

   public ConstantValue getLeft() {
      return left;
   }

   public ConstantValue getRight() {
      return right;
   }

   @Override
   public SymbolType getType(ProgramScope scope) {
      return SymbolTypeInference.inferType(scope, left, operator, right);
   }

   @Override
   public String toString(Program program) {
      return left.toString(program) + operator.toString() + right.toString(program);
   }

   @Override
   public String toString() {
      return toString(null);
   }

}
