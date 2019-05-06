package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.InternalError;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.BinaryExpressionIterator;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeInference;
import dk.camelot64.kickc.model.types.SymbolTypeIntegerFixed;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;
import dk.camelot64.kickc.model.values.ConstantValue;
import dk.camelot64.kickc.model.values.RValue;

/**
 * Add casts to {@link SymbolType#NUMBER} expressions that meet a typed value in a binary expression (including assignment)
 */
public class PassNAddNumberTypeConversions extends Pass2SsaOptimization {

   public PassNAddNumberTypeConversions(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      BinaryExpressionIterator.execute(getProgram(), (binaryExpression, currentStmt, stmtIt, currentBlock) -> {
         RValue left = binaryExpression.getLeft();
         RValue right = binaryExpression.getRight();
         SymbolType conversionType = getNumberConversionType(left, right);
         if(conversionType != null) {
            // Convert both left and right to the found type

            getLog().append("Adding number conversion cast (" + fixedType+ ") " + binaryExpression.getRight().toString() + " in " + currentStmt.toString(getProgram(), false));


         }

      });
      return false;
   }

   private SymbolType getNumberConversionType(RValue left, RValue right) {

      SymbolType leftType = SymbolTypeInference.inferType(getProgram().getScope(), left);
      SymbolType rightType = SymbolTypeInference.inferType(getProgram().getScope(), right);

      if(SymbolType.NUMBER.equals(leftType) || SymbolType.NUMBER.equals(rightType)) {
         // A special type number is assigned to integer constants without a postfix literal.
         // Numbers are flexible and will take a type based on their actual value when they meet a typed number in a calculation.
         // Number types are only usable at compile time.

         if(leftType.equals(rightType)) {
            // a) If the two operands are numbers the result is a number
            return null;
         }

         RValue numberVal;
         SymbolTypeIntegerFixed fixedType;
         if(SymbolType.NUMBER.equals(leftType) && SymbolType.isInteger(rightType)) {
            // Left is the number
            numberVal = left;
            fixedType = (SymbolTypeIntegerFixed) rightType;
         } else if(SymbolType.NUMBER.equals(rightType) && SymbolType.isInteger(leftType)) {
            // Right is the number
            numberVal = right;
            fixedType = (SymbolTypeIntegerFixed) leftType;
         } else {
            // Non-integer number binary
            throw new CompileError("Error! Incompatible operands "+left.toString()+" and "+right.toString());
         }

         if(numberVal instanceof ConstantValue) {
            ConstantLiteral constantLiteral = ((ConstantValue) numberVal).calculateLiteral(getProgram().getScope());
            if(constantLiteral instanceof ConstantInteger) {
               ConstantInteger constantInteger = (ConstantInteger) constantLiteral;
               if(SymbolType.NUMBER.equals(constantInteger.getType())) {
                  Long value = constantInteger.getValue();
                  if(fixedType.getMinValue() <= value && fixedType.getMaxValue() >= value) {
                     // The value matches the left type!
                     binaryExpression.addRightCast(leftIntType);
                  } else {
                     throw new InternalError("TODO: Implement number conversion for non-equal types " + right.toString(), currentStmt);
                  }
               } else {
                  throw new InternalError("Non-number constant has type number " + right.toString(), currentStmt);
               }
            }
         } else {
            // Postpone til later!
            // Maybe handle AssignmentRValue separately!
            getLog().append("Postponed number conversion " + right.toString());
         }




      }

      // No number conversion
      return null;

      if(SymbolType.isInteger(leftType) && !SymbolType.NUMBER.equals(leftType) && SymbolType.NUMBER.equals(rightType)) {
         SymbolTypeIntegerFixed leftIntType = (SymbolTypeIntegerFixed) leftType;
         // Attempt to find number conversion!
      }

      return null;
   }


}
