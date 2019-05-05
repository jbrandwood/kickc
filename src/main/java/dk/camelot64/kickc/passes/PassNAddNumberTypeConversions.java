package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.InternalError;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.BinaryExpressionIterator;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeInference;
import dk.camelot64.kickc.model.types.SymbolTypeIntegerFixed;
import dk.camelot64.kickc.model.values.*;

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

         SymbolType leftType = SymbolTypeInference.inferType(getScope(), left);
         SymbolType rightType = SymbolTypeInference.inferType(getScope(), right);
         if(SymbolType.isInteger(leftType) && !SymbolType.NUMBER.equals(leftType) && SymbolType.NUMBER.equals(rightType)) {
            SymbolTypeIntegerFixed leftIntType = (SymbolTypeIntegerFixed) leftType;
            // Attempt to find number conversion!
            if(right instanceof ConstantValue) {
               ConstantLiteral constantLiteral = ((ConstantValue) right).calculateLiteral(getProgram().getScope());
               if(constantLiteral instanceof ConstantInteger) {
                  ConstantInteger constantInteger = (ConstantInteger) constantLiteral;
                  if(SymbolType.NUMBER.equals(constantInteger.getType())) {
                     Long value = constantInteger.getValue();
                     if(leftIntType.getMinValue()<=value && leftIntType.getMaxValue()>=value) {
                        // The value matches the left type!
                        getLog().append("Adding number conversion cast ("+leftIntType+") "+binaryExpression.getRight().toString()+" in "+currentStmt.toString(getProgram(), false));
                        binaryExpression.addRightCast(leftIntType);
                     }  else {
                        throw new InternalError("TODO: Implement number conversion for non-equal types "+right.toString(), currentStmt);
                     }
                  } else {
                     throw new InternalError("Non-number constant has type number "+right.toString(), currentStmt);
                  }
               }
            }  else {
               // Postpone til later!
               // Maybe handle AssignmentRValue separately!
               getLog().append("Postponed number conversion " + right.toString());
            }
         }
      });
      return false;
   }


}
