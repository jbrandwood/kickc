package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramExpressionBinary;
import dk.camelot64.kickc.model.iterator.ProgramExpressionIterator;
import dk.camelot64.kickc.model.types.*;
import dk.camelot64.kickc.model.values.RValue;

import java.util.concurrent.atomic.AtomicBoolean;

/**
 * Add a cast a variable is assigned something of a convertible type.
 * Also allows pointers to be assigned integer values.
 */
public class PassNAddTypeConversionAssignment extends Pass2SsaOptimization {

   public PassNAddTypeConversionAssignment(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      AtomicBoolean modified = new AtomicBoolean(false);
      ProgramExpressionIterator.execute(getProgram(), (programExpression, currentStmt, stmtIt, currentBlock) -> {
         if(programExpression instanceof ProgramExpressionBinary) {
            ProgramExpressionBinary binary = (ProgramExpressionBinary) programExpression;
            RValue left = binary.getLeft();
            RValue right = binary.getRight();
            SymbolType leftType = SymbolTypeInference.inferType(getProgram().getScope(), left);
            SymbolType rightType = SymbolTypeInference.inferType(getProgram().getScope(), right);

            if(!SymbolTypeConversion.assignmentTypeMatch(leftType, rightType)) {
               // Assigning a pointer from an unsigned word
               if(programExpression instanceof ProgramExpressionBinary.ProgramExpressionBinaryAssignmentLValue) {
                  if((leftType instanceof SymbolTypePointer) && SymbolType.isInteger(rightType)) {
                     getLog().append("Adding pointer type conversion cast (" + leftType + ") " + binary.getLeft().toString() + " in " + currentStmt.toString(getProgram(), false));
                     binary.addRightCast(leftType, stmtIt, currentBlock.getScope(), getScope());
                     modified.set(true);
                  }
               }
               if(leftType instanceof SymbolTypeIntegerFixed && SymbolType.isInteger(rightType)) {
                  SymbolType conversionType = SymbolTypeConversion.convertedMathType((SymbolTypeInteger) leftType, (SymbolTypeInteger) rightType);
                  // Add cast to the right Type if needed
                  if(leftType.equals(conversionType) && !rightType.equals(conversionType)) {
                     getLog().append("Adding type conversion cast (" + conversionType + ") " + binary.getRight().toString() + " in " + (currentStmt == null ? "" : currentStmt.toString(getProgram(), false)));
                     binary.addRightCast(conversionType, stmtIt, currentBlock == null ? null : currentBlock.getScope(), getScope());
                     modified.set(true);
                  }
               }
            }
         }
      });
      return modified.get();
   }


}
