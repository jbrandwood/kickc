package dk.camelot64.kickc.model;

import dk.camelot64.kickc.model.operators.Operator;
import dk.camelot64.kickc.model.operators.Operators;
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
         return calcValue(programScope, unary.getOperator(), unary.getOperand());
      } else if(value instanceof ConstantBinary) {
         ConstantBinary binary = (ConstantBinary) value;
         return calcValue(programScope, binary.getLeft(), binary.getOperator(), binary.getRight());
      } else if(value instanceof ConstantArrayList) {
         // Cannot calculate value of inline array
         return null;
      } else if(value instanceof ConstantArrayFilled) {
         // Cannot calculate value of inline array
         return null;
      } else {
         throw new RuntimeException("Unknown constant value " + value);
      }
   }


   public static ConstantLiteral calcValue(ProgramScope programScope, Operator operator, ConstantValue value) {
      if(operator.equals(Operators.NEG)) {
         return neg(calcValue(programScope, value));
      } else if(operator.equals(Operators.POS)) {
         return pos(calcValue(programScope, value));
      } else if(operator.equals(Operators.CAST_WORD)) {
         return castWord(calcValue(programScope, value));
      } else if(operator.equals(Operators.CAST_SWORD)) {
         return castSWord(calcValue(programScope, value));
      } else if(operator.equals(Operators.CAST_BYTE)) {
         return castByte(calcValue(programScope, value));
      } else if(operator.equals(Operators.CAST_SBYTE)) {
         return castSByte(calcValue(programScope, value));
      }
      return null;
   }

   private static ConstantLiteral castWord(ConstantValue value) {
      if(value instanceof ConstantInteger) {
         return new ConstantInteger(0xffff & ((ConstantInteger) value).getValue());
      }
      return null;
   }

   private static ConstantLiteral castSWord(ConstantValue value) {
      if(value instanceof ConstantInteger) {
         return new ConstantInteger(0xffff & ((ConstantInteger) value).getValue());
      }
      return null;
   }

   private static ConstantLiteral castByte(ConstantValue value) {
      if(value instanceof ConstantInteger) {
         return new ConstantInteger(0xff & ((ConstantInteger) value).getValue());
      }
      return null;
   }

   private static ConstantLiteral castSByte(ConstantValue value) {
      if(value instanceof ConstantInteger) {
         return new ConstantInteger(0xff & ((ConstantInteger) value).getValue());
      }
      return null;
   }

   private static ConstantLiteral castPtrByte(ConstantLiteral value) {
      return value;
   }

   public static ConstantLiteral calcValue(ProgramScope programScope, ConstantValue value1, Operator operator, ConstantValue value2) {
      if(operator.equals(Operators.MULTIPLY)) {
         return multiply(calcValue(programScope, value1), calcValue(programScope, value2));
      } else if(operator.equals(Operators.PLUS)) {
         return plus(calcValue(programScope, value1), calcValue(programScope, value2));
      } else if(operator.equals(Operators.MINUS)) {
         return minus(calcValue(programScope, value1), calcValue(programScope, value2));
      } else if(operator.equals(Operators.DIVIDE)) {
         return div(calcValue(programScope, value1), calcValue(programScope, value2));
      }
      return null;
   }

   private static ConstantLiteral neg(ConstantLiteral value) {
      if(value instanceof ConstantInteger) {
         return new ConstantInteger(-((ConstantInteger) value).getValue());
      }
      return null;
   }

   private static ConstantLiteral pos(ConstantLiteral value) {
      if(value instanceof ConstantInteger) {
         return new ConstantInteger(+((ConstantInteger) value).getValue());
      }
      return null;
   }

   private static ConstantLiteral multiply(ConstantLiteral value1, ConstantLiteral value2) {
      if(value1 instanceof ConstantInteger && value2 instanceof ConstantInteger) {
         return new ConstantInteger(((ConstantInteger) value1).getValue() * ((ConstantInteger) value2).getValue());
      }
      return null;
   }

   private static ConstantLiteral plus(ConstantLiteral value1, ConstantLiteral value2) {
      if(value1 instanceof ConstantInteger && value2 instanceof ConstantInteger) {
         return new ConstantInteger(((ConstantInteger) value1).getValue() + ((ConstantInteger) value2).getValue());
      }
      if(value1 instanceof ConstantInteger && value2 instanceof ConstantChar) {
         return new ConstantInteger(((ConstantInteger) value1).getValue() + ((ConstantChar) value2).getValue());
      }
      if(value1 instanceof ConstantChar && value2 instanceof ConstantInteger) {
         return new ConstantInteger(((ConstantChar) value1).getValue() + ((ConstantInteger) value2).getValue());
      }
      if(value1 instanceof ConstantString && value2 instanceof ConstantString) {
         return new ConstantString(((ConstantString) value1).getValue() + ((ConstantString) value2).getValue());
      }
      if(value1 instanceof ConstantString && value2 instanceof ConstantChar) {
         return new ConstantString(((ConstantString) value1).getValue() + ((ConstantChar) value2).getValue());
      }
      return null;
   }

   private static ConstantLiteral minus(ConstantLiteral value1, ConstantLiteral value2) {
      if(value1 instanceof ConstantInteger && value2 instanceof ConstantInteger) {
         return new ConstantInteger(((ConstantInteger) value1).getValue() - ((ConstantInteger) value2).getValue());
      }
      return null;
   }

   private static ConstantLiteral div(ConstantLiteral value1, ConstantLiteral value2) {
      if(value1 instanceof ConstantInteger && value2 instanceof ConstantInteger) {
         return new ConstantInteger(((ConstantInteger) value1).getValue() / ((ConstantInteger) value2).getValue());
      }
      return null;
   }

}
