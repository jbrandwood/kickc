package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramExpressionBinary;
import dk.camelot64.kickc.model.iterator.ProgramExpressionIterator;
import dk.camelot64.kickc.model.types.*;
import dk.camelot64.kickc.model.values.RValue;
import dk.camelot64.kickc.model.values.ValueList;

import java.util.List;
import java.util.concurrent.atomic.AtomicBoolean;

/**
 * Add a cast a variable is assigned something of a convertible type.
 * Also allows pointers to be assigned integer values.
 */
public class PassNAddTypeConversionAssignment extends Pass2SsaOptimization {

   private boolean pass2;

   public PassNAddTypeConversionAssignment(Program program, boolean pass2) {
      super(program);
      this.pass2 = pass2;
   }

   @Override
   public boolean step() {
      AtomicBoolean modified = new AtomicBoolean(false);
      ProgramExpressionIterator.execute(getProgram(), (programExpression, currentStmt, stmtIt, currentBlock) -> {
         if(programExpression instanceof ProgramExpressionBinary) {
            ProgramExpressionBinary binary = (ProgramExpressionBinary) programExpression;
            RValue left = binary.getLeft();
            RValue right = binary.getRight();
            SymbolType leftType;
            SymbolType rightType;
            try {
               leftType = SymbolTypeInference.inferType(getProgram().getScope(), left);
               rightType = SymbolTypeInference.inferType(getProgram().getScope(), right);
            } catch(CompileError e) {
               throw new CompileError(e.getMessage(), currentStmt.getSource());
            }
            if(!SymbolTypeConversion.assignmentTypeMatch(leftType, rightType) || SymbolType.VAR.equals(rightType)) {
               // Assigning a pointer from an unsigned word
               if(programExpression instanceof ProgramExpressionBinary.ProgramExpressionBinaryAssignmentLValue || programExpression instanceof ProgramExpressionBinary.ProgramExpressionBinaryCallParameter) {
                  if((leftType instanceof SymbolTypePointer) && SymbolType.isInteger(rightType)) {
                     if(pass2 || getLog().isVerbosePass1CreateSsa())
                        getLog().append("Adding pointer type conversion cast (" + leftType + ") " + binary.getLeft().toString() + " in " + currentStmt.toString(getProgram(), false));
                     binary.addRightCast(leftType, stmtIt, currentBlock.getScope(), getScope());
                     modified.set(true);
                  } else if((leftType instanceof SymbolTypePointer) && rightType instanceof SymbolTypePointer && SymbolType.VOID.equals(((SymbolTypePointer) leftType).getElementType())) {
                     if(pass2 || getLog().isVerbosePass1CreateSsa())
                        getLog().append("Adding void pointer type conversion cast (" + leftType + ") " + binary.getRight().toString() + " in " + currentStmt.toString(getProgram(), false));
                     binary.addRightCast(leftType, stmtIt, currentBlock.getScope(), getScope());
                     modified.set(true);
                  } else if((leftType instanceof SymbolTypePointer) && rightType instanceof SymbolTypePointer && SymbolType.VOID.equals(((SymbolTypePointer) rightType).getElementType())) {
                     if(pass2 || getLog().isVerbosePass1CreateSsa())
                        getLog().append("Adding pointer type conversion cast to void pointer (" + leftType + ") " + binary.getRight().toString() + " in " + currentStmt.toString(getProgram(), false));
                     binary.addRightCast(leftType, stmtIt, currentBlock.getScope(), getScope());
                     modified.set(true);
                  } else if((leftType instanceof SymbolTypePointer) && SymbolType.STRING.equals(rightType) && SymbolType.VOID.equals(((SymbolTypePointer) leftType).getElementType())) {
                     if(pass2 || getLog().isVerbosePass1CreateSsa())
                        getLog().append("Adding void pointer type conversion cast (" + leftType + ") " + binary.getRight().toString() + " in " + currentStmt.toString(getProgram(), false));
                     binary.addRightCast(leftType, stmtIt, currentBlock.getScope(), getScope());
                     modified.set(true);
                  } else if(leftType.equals(SymbolType.STRING) && rightType instanceof SymbolTypePointer && SymbolType.VOID.equals(((SymbolTypePointer) rightType).getElementType())) {
                     if(pass2 || getLog().isVerbosePass1CreateSsa())
                        getLog().append("Adding pointer type conversion cast to void pointer (" + leftType + ") " + binary.getRight().toString() + " in " + currentStmt.toString(getProgram(), false));
                     binary.addRightCast(leftType, stmtIt, currentBlock.getScope(), getScope());
                     modified.set(true);
                  } else if(SymbolType.WORD.equals(leftType) && isLiteralWordCandidate(right)) {
                     // Detect word literal constructor
                     SymbolType conversionType = SymbolType.WORD;
                     if(pass2 || getLog().isVerbosePass1CreateSsa())
                        getLog().append("Identified literal word (" + conversionType + ") " + binary.getRight().toString() + " in " + (currentStmt == null ? "" : currentStmt.toString(getProgram(), false)));
                     binary.addRightCast(conversionType, stmtIt, currentBlock == null ? null : currentBlock.getScope(), getScope());
                     modified.set(true);
                  } else if(leftType instanceof SymbolTypePointer && !(leftType instanceof SymbolTypeArray) && isLiteralWordCandidate(right)) {
                     // Detect word literal constructor
                     SymbolType conversionType = SymbolType.WORD;
                     if(pass2 || getLog().isVerbosePass1CreateSsa())
                        getLog().append("Identified literal word (" + conversionType + ") " + binary.getRight().toString() + " in " + (currentStmt == null ? "" : currentStmt.toString(getProgram(), false)));
                     binary.addRightCast(conversionType, stmtIt, currentBlock == null ? null : currentBlock.getScope(), getScope());
                     modified.set(true);
                  } else if(SymbolType.DWORD.equals(leftType) && isLiteralWordCandidate(right)) {
                     // Detect dword literal constructor
                     SymbolType conversionType = SymbolType.DWORD;
                     if(pass2 || getLog().isVerbosePass1CreateSsa())
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

   private boolean isLiteralWordCandidate(RValue rValue) {
      if(rValue instanceof ValueList) {
         List<RValue> list = ((ValueList) rValue).getList();
         if(list.size() == 2) {
            for(RValue elm : list) {
               if(!SymbolType.isInteger(SymbolTypeInference.inferType(getProgram().getScope(), elm))) {
                  return false;
               }
            }
            // Two integer elements
            return true;
         }
      }
      return false;
   }

}
