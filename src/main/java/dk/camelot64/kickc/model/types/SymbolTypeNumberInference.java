package dk.camelot64.kickc.model.types;

import dk.camelot64.kickc.model.InternalError;
import dk.camelot64.kickc.model.operators.OperatorBinary;
import dk.camelot64.kickc.model.operators.OperatorUnary;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;
import dk.camelot64.kickc.model.values.ConstantValue;
import dk.camelot64.kickc.model.values.RValue;

import java.util.ArrayList;
import java.util.List;

/**
 * Interference of possible types for constant expressions with the {@link SymbolType#NUMBER} type.
 * This is done by evaluating the constant expression to find the literal value.
 */
public class SymbolTypeNumberInference {

   /**
    * Infer the potential types for an RValue with {@link SymbolType#NUMBER} type
    *
    * @return The potential types
    */
   public static List<SymbolTypeIntegerFixed> inferTypesRValue(ProgramScope symbols, StatementAssignment assignment) {
      RValue rValue1 = assignment.getrValue1();
      RValue rValue2 = assignment.getrValue2();
      if(assignment.getrValue1() == null && assignment.getOperator() == null && assignment.getrValue2() instanceof ConstantValue) {
         return inferTypes(symbols, (ConstantValue) rValue2);
      } else if(assignment.getrValue1() == null && assignment.getOperator() instanceof OperatorUnary && assignment.getrValue2() instanceof ConstantValue) {
         return inferTypes(symbols, (OperatorUnary) assignment.getOperator(), (ConstantValue) rValue2);
      } else if(assignment.getOperator() instanceof OperatorBinary && assignment.getrValue1() instanceof ConstantValue && assignment.getrValue2() instanceof ConstantValue) {
         return inferTypes(symbols, (ConstantValue) rValue1, (OperatorBinary) assignment.getOperator(), (ConstantValue) rValue2);
      } else {
         return new ArrayList<>();
      }
   }

   /**
    * Infer the potential types for a binary operator with {@link SymbolType#NUMBER} type
    *
    * @return The potential types
    */
   public static List<SymbolTypeIntegerFixed> inferTypes(ProgramScope programScope, ConstantValue leftValue, OperatorBinary operator, ConstantValue rightValue) {
      if(SymbolType.NUMBER.equals(leftValue.getType(programScope)) && SymbolType.NUMBER.equals(rightValue.getType(programScope))) {
         // Calculate resulting constant literal
         ConstantLiteral leftLiteral = leftValue.calculateLiteral(programScope);
         ConstantLiteral rightLiteral = rightValue.calculateLiteral(programScope);
         ConstantLiteral constantLiteral = operator.calculateLiteral(leftLiteral, rightLiteral);
         return inferTypes(programScope, constantLiteral);
      } else {
         throw new InternalError("Both operands must be number type.");
      }
   }

   /**
    * Infer the potential types for a unary operator with {@link SymbolType#NUMBER} type
    *
    * @return The potential types
    */
   public static List<SymbolTypeIntegerFixed> inferTypes(ProgramScope programScope, OperatorUnary operator, ConstantValue constantValue) {
      if(SymbolType.NUMBER.equals(constantValue.getType(programScope))) {
         // Calculate resulting constant literal
         ConstantLiteral operandLiteral = constantValue.calculateLiteral(programScope);
         ConstantLiteral constantLiteral = operator.calculateLiteral(operandLiteral, programScope);
         return inferTypes(programScope, constantLiteral);
      } else {
         throw new InternalError("Operand must be number type.");
      }
   }

   /**
    * Infer the potential types for a constant value with {@link SymbolType#NUMBER} type
    *
    * @return The potential types
    */
   public static List<SymbolTypeIntegerFixed> inferTypes(ProgramScope programScope, ConstantValue constantValue) {
      // Calculate resulting constant literal
      ConstantLiteral constantLiteral = constantValue.calculateLiteral(programScope);
      return inferTypes(programScope, constantLiteral);
   }

   /**
    * Infer the potential types for a constant literal with {@link SymbolType#NUMBER} type
    */
   public static List<SymbolTypeIntegerFixed> inferTypes(ProgramScope programScope, ConstantLiteral literal) {
      if(literal instanceof ConstantInteger && SymbolType.NUMBER.equals(literal.getType(programScope))) {
         ArrayList<SymbolTypeIntegerFixed> potentialTypes = new ArrayList<>();
         ConstantInteger constantInteger = (ConstantInteger) literal;
         Long number = constantInteger.getValue();
         for(SymbolTypeIntegerFixed typeInteger : SymbolTypeIntegerFixed.getIntegerFixedTypes()) {
            if(typeInteger.contains(number)) {
               potentialTypes.add(typeInteger);
            }
         }
         return potentialTypes;
      } else {
         throw new InternalError("Literal must number type.");
      }
   }

}
