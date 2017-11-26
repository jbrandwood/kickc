package dk.camelot64.kickc.model;

/** Can calculate the exact value for constants (used for type inference).*/
public class ConstantValueCalculator {


   private static ConstantValue calcValue(ProgramScope programScope, ConstantValue value) {
      if(value instanceof ConstantInteger) {
         return value;
      } else if(value instanceof ConstantString) {
         return value;
      } else if(value instanceof ConstantChar) {
         ConstantChar charValue = (ConstantChar) value;
         return new ConstantInteger((int)charValue.getValue());
      } else if(value instanceof ConstantRef) {
         ConstantVar constantVar = programScope.getConstant((ConstantRef) value);
         ConstantValue constantVarValue = constantVar.getValue();
         return calcValue(programScope, constantVarValue);
      } else if(value instanceof ConstantUnary) {
         ConstantUnary unary = (ConstantUnary) value;
         return calcValue(programScope, unary.getOperator(), unary.getOperand());
      } else if(value instanceof ConstantBinary) {
         ConstantBinary binary = (ConstantBinary) value;
         return calcValue(programScope, binary.getLeft(), binary.getOperator(), binary.getRight());
      } else if(value instanceof ConstantArray) {
         // Cannot calculate value of inline array
         return null;
      } else {
         throw new RuntimeException("Unknown constant value "+value);
      }
   }


   public static ConstantValue calcValue(ProgramScope programScope, Operator operator, ConstantValue value) {
      if(operator.equals(Operator.NEG)) {
         return neg(calcValue(programScope, value));
      } else if(operator.equals(Operator.POS)) {
         return pos(calcValue(programScope, value));
      }
      return null;
   }

   public static ConstantValue calcValue(ProgramScope programScope, ConstantValue value1, Operator operator, ConstantValue value2) {
      if(operator.equals(Operator.MULTIPLY)) {
         return multiply(calcValue(programScope, value1), calcValue(programScope, value2));
      } else if(operator.equals(Operator.PLUS)) {
         return plus(calcValue(programScope, value1), calcValue(programScope, value2));
      } else if(operator.equals(Operator.MINUS)) {
         return minus(calcValue(programScope, value1), calcValue(programScope, value2));
      } else if(operator.equals(Operator.DIVIDE)) {
         return div(calcValue(programScope, value1), calcValue(programScope, value2));
      }
      return null;
   }

   private static ConstantValue neg(ConstantValue value) {
      if(value instanceof ConstantInteger) {
         return new ConstantInteger(-((ConstantInteger) value).getNumber());
      }
      return null;
   }

   private static ConstantValue pos(ConstantValue value) {
      if(value instanceof ConstantInteger) {
         return new ConstantInteger(+((ConstantInteger) value).getNumber());
      }
      return null;
   }

   private static ConstantValue multiply(ConstantValue value1, ConstantValue value2) {
      if(value1 instanceof ConstantInteger && value2 instanceof ConstantInteger) {
         return new ConstantInteger(((ConstantInteger) value1).getNumber()*((ConstantInteger) value2).getNumber());
      }
      return null;
   }

   private static ConstantValue plus(ConstantValue value1, ConstantValue value2) {
      if(value1 instanceof ConstantInteger && value2 instanceof ConstantInteger) {
         return new ConstantInteger(((ConstantInteger) value1).getNumber()+((ConstantInteger) value2).getNumber());
      }
      return null;
   }

   private static ConstantValue minus(ConstantValue value1, ConstantValue value2) {
      if(value1 instanceof ConstantInteger && value2 instanceof ConstantInteger) {
         return new ConstantInteger(((ConstantInteger) value1).getNumber()-((ConstantInteger) value2).getNumber());
      }
      return null;
   }

   private static ConstantValue div(ConstantValue value1, ConstantValue value2) {
      if(value1 instanceof ConstantInteger && value2 instanceof ConstantInteger) {
         return new ConstantInteger(((ConstantInteger) value1).getNumber()/((ConstantInteger) value2).getNumber());
      }
      return null;
   }

}
