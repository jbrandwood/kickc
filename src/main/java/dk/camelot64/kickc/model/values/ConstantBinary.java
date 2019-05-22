package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.operators.OperatorBinary;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeInference;

/** A constant defined by a binary operator applied to two constants */
public class ConstantBinary implements ConstantValue {

   /** The left constant operand. */
   private ConstantValue left;

   /** The operator, */
   private OperatorBinary operator;

   /** The right constant operand. */
   private ConstantValue right;

   public ConstantBinary(ConstantValue left, OperatorBinary operator, ConstantValue right) {
      this.left = left;
      this.operator = operator;
      this.right = right;
   }

   public OperatorBinary getOperator() {
      return operator;
   }

   public ConstantValue getLeft() {
      return left;
   }

   public ConstantValue getRight() {
      return right;
   }

   public void setLeft(ConstantValue left) {
      this.left = left;
   }

   public void setOperator(OperatorBinary operator) {
      this.operator = operator;
   }

   public void setRight(ConstantValue right) {
      this.right = right;
   }

   @Override
   public ConstantLiteral calculateLiteral(ProgramScope scope) {
      ConstantLiteral literal = operator.calculateLiteral(left.calculateLiteral(scope), right.calculateLiteral(scope));
      if(literal instanceof ConstantInteger && SymbolType.NUMBER.equals(literal.getType(scope))) {
         ((ConstantInteger) literal).setType(getType(scope));
      }
      return literal;
   }

   @Override
   public SymbolType getType(ProgramScope scope) {
      SymbolType leftType = SymbolTypeInference.inferType(scope, left);
      SymbolType rightType = SymbolTypeInference.inferType(scope, right);
      return operator.inferType(leftType, rightType);
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
