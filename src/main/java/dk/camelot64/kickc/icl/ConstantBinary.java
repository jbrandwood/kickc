package dk.camelot64.kickc.icl;

import dk.camelot64.kickc.passes.Pass1TypeInference;

/** A constant defined by a binary operator applied to two constants */
public class ConstantBinary implements ConstantValue {

   /** The left constant operand. */
   private Constant left;

   /** The operator, */
   private Operator operator;

   /** The right constant operand. */
   private Constant right;

   public ConstantBinary(Constant left, Operator operator, Constant right) {
      this.left = left;
      this.operator = operator;
      this.right = right;
   }

   public Operator getOperator() {
      return operator;
   }

   public Constant getLeft() {
      return left;
   }

   public Constant getRight() {
      return right;
   }

   @Override
   public SymbolType getType(ProgramScope scope) {
      return Pass1TypeInference.inferType(left.getType(scope), operator, right.getType(scope));
   }

   @Override
   public String toString(Program program) {
      return left.toString(program)+operator.toString()+right.toString(program);
   }

   @Override
   public String toString() {
      return toString(null);
   }

}
