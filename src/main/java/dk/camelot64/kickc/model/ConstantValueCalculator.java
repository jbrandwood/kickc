package dk.camelot64.kickc.model;

import dk.camelot64.kickc.model.values.*;
import dk.camelot64.kickc.model.symbols.ConstantVar;
import dk.camelot64.kickc.model.symbols.ProgramScope;

/** Can calculate the exact value for constants (used for type inference). */
public class ConstantValueCalculator {

   public static ConstantLiteral calcValue(ProgramScope programScope, ConstantValue value) {
      if(value instanceof ConstantInteger) {
         return (ConstantLiteral) value;
      } else if(value instanceof ConstantString) {
         return (ConstantLiteral) value;
      } else if(value instanceof ConstantChar) {
         return (ConstantLiteral) value;
      } else if(value instanceof ConstantRef) {
         ConstantVar constantVar = programScope.getConstant((ConstantRef) value);
         ConstantValue constantVarValue = constantVar.getValue();
         return calcValue(programScope, constantVarValue);
      } else if(value instanceof ConstantUnary) {
         ConstantUnary unary = (ConstantUnary) value;
         return unary.getOperator().calculate(calcValue(programScope, unary.getOperand()));
      } else if(value instanceof ConstantBinary) {
         ConstantBinary binary = (ConstantBinary) value;
         return binary.getOperator().calculate(calcValue(programScope, binary.getLeft()), calcValue(programScope, binary.getRight()));
      } else if(value instanceof ConstantArrayList) {
         // Cannot calculate value of inline array
         throw new ConstantNotLiteral("Not literal "+value.toString());
      } else if(value instanceof ConstantArrayFilled) {
         // Cannot calculate value of inline array
         throw new ConstantNotLiteral("Not literal "+value.toString());
      } else {
         throw new RuntimeException("Unknown constant value " + value);
      }
   }

}
