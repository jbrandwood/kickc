package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramExpressionBinary;
import dk.camelot64.kickc.model.iterator.ProgramExpressionIterator;
import dk.camelot64.kickc.model.types.*;
import dk.camelot64.kickc.model.values.ConstantInteger;
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

                  // Detect word literal constructor
                  if(SymbolType.WORD.equals(leftType) && isLiteralWordCandidate(rightType)) {
                     SymbolType conversionType = SymbolType.WORD;
                     getLog().append("Identified literal word (" + conversionType + ") " + binary.getRight().toString() + " in " + (currentStmt == null ? "" : currentStmt.toString(getProgram(), false)));
                     binary.addRightCast(conversionType, stmtIt, currentBlock == null ? null : currentBlock.getScope(), getScope());
                     modified.set(true);
                  }
                  // Detect word literal constructor
                  if(leftType instanceof SymbolTypePointer && isLiteralWordCandidate(rightType)) {
                     SymbolType conversionType = SymbolType.WORD;
                     getLog().append("Identified literal word (" + conversionType + ") " + binary.getRight().toString() + " in " + (currentStmt == null ? "" : currentStmt.toString(getProgram(), false)));
                     binary.addRightCast(conversionType, stmtIt, currentBlock == null ? null : currentBlock.getScope(), getScope());
                     modified.set(true);
                  }

                  // Detect dword literal constructor
                  if(SymbolType.DWORD.equals(leftType) && isLiteralWordCandidate(rightType)) {
                     SymbolType conversionType = SymbolType.DWORD;
                     getLog().append("Identified literal word (" + conversionType + ") " + binary.getRight().toString() + " in " + (currentStmt == null ? "" : currentStmt.toString(getProgram(), false)));
                     binary.addRightCast(conversionType, stmtIt, currentBlock == null ? null : currentBlock.getScope(), getScope());
                     modified.set(true);
                  }

               }
            }
         }
      });
      return modified.get();
   }

   public static boolean isLiteralWordCandidate(SymbolType rightType) {
      if(rightType instanceof SymbolTypeArray) {
         SymbolTypeArray rightArray = (SymbolTypeArray) rightType;
         if(new ConstantInteger(2L, SymbolType.BYTE).equals(rightArray.getSize()))
            if(SymbolType.isInteger(rightArray.getElementType()))
               return true;
      }
      return false;
   }

}
