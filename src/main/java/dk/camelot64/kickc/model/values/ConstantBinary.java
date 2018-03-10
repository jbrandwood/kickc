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

   @Override
   public ConstantLiteral calculateLiteral(ProgramScope scope) {
      return operator.calculate(left.calculateLiteral(scope), right.calculateLiteral(scope));
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
