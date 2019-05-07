package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramExpressionBinary;
import dk.camelot64.kickc.model.iterator.ProgramExpressionIterator;
import dk.camelot64.kickc.model.types.*;
import dk.camelot64.kickc.model.values.RValue;

/**
 * Add casts in binary expressions where left/right types are not equal according to the C99 type conversion rules
 * 6.3.1.8 http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1570.pdf#page=70.
 */
public class PassNAddTypeConversionsNew extends Pass2SsaOptimization {

   public PassNAddTypeConversionsNew(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      ProgramExpressionIterator.execute(getProgram(), (programExpression, currentStmt, stmtIt, currentBlock) -> {
         if(programExpression instanceof ProgramExpressionBinary) {
            ProgramExpressionBinary binary = (ProgramExpressionBinary) programExpression;
            RValue left = binary.getLeft();
            RValue right = binary.getRight();
            SymbolType leftType = SymbolTypeInference.inferType(getProgram().getScope(), left);
            SymbolType rightType = SymbolTypeInference.inferType(getProgram().getScope(), right);

            // Special handling of assigning a pointer from an unsigned word
            if((programExpression instanceof ProgramExpressionBinary.ProgramExpressionBinaryAssignmentLValue) && (leftType instanceof SymbolTypePointer) && SymbolType.isInteger(rightType)) {
               getLog().append("Adding pointer type conversion cast (" + leftType + ") " + binary.getLeft().toString() + " in " + currentStmt.toString(getProgram(), false));
               binary.addRightCast(leftType, stmtIt, currentBlock.getScope(), getScope());
            }

            if(SymbolType.isInteger(leftType) && SymbolType.isInteger(rightType)) {
               SymbolType conversionType = SymbolTypeConversion.convertedMathType((SymbolTypeInteger) leftType, (SymbolTypeInteger) rightType);
               if(conversionType != null && !SymbolType.NUMBER.equals(conversionType)) {
                  // Convert both left and right to the found type
                  if(!leftType.equals(conversionType)) {
                     getLog().append("Adding type conversion cast (" + conversionType + ") " + binary.getLeft().toString() + " in " + currentStmt.toString(getProgram(), false));
                     binary.addLeftCast(conversionType, stmtIt, currentBlock.getScope(), getScope());
                  }
                  if(!rightType.equals(conversionType)) {
                     getLog().append("Adding type conversion cast (" + conversionType + ") " + binary.getRight().toString() + " in " + currentStmt.toString(getProgram(), false));
                     binary.addRightCast(conversionType, stmtIt, currentBlock.getScope(), getScope());
                  }
               }
            }
         }
      });
      return false;
   }


}
