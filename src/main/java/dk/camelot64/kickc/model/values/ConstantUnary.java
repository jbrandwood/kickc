package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.operators.OperatorUnary;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeInference;

/** A constant defined by a unary operator appied to another constant */
public class ConstantUnary implements ConstantValue {

   /** The operator, */
   private OperatorUnary operator;

   /** The constant operand. */
   private ConstantValue operand;

   public ConstantUnary(OperatorUnary operator, ConstantValue operand) {
      this.operator = operator;
      this.operand = operand;
   }

   public OperatorUnary getOperator() {
      return operator;
   }

   public ConstantValue getOperand() {
      return operand;
   }

   @Override
   public ConstantLiteral calculateLiteral(ProgramScope scope) {
      return operator.calculate(operand.calculateLiteral(scope));
   }

   @Override
   public SymbolType getType(ProgramScope scope) {
      return SymbolTypeInference.inferType(scope, operator, operand);
   }

   @Override
   public boolean equals(Object o) {
      if(this == o) {
         return true;
      }
      if(o == null || getClass() != o.getClass()) {
         return false;
      }
      ConstantUnary that = (ConstantUnary) o;
      if(!operator.equals(that.operator)) {
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
      return operator.toString() + operand.toString(program);
   }

   @Override
   public String toString() {
      return toString(null);
   }


}
