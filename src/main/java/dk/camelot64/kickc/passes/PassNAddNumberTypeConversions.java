package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramExpressionBinary;
import dk.camelot64.kickc.model.iterator.ProgramExpressionIterator;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeConversion;
import dk.camelot64.kickc.model.types.SymbolTypeInference;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
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
      ProgramExpressionIterator.execute(getProgram(), (binaryExpression, currentStmt, stmtIt, currentBlock) -> {
         if(binaryExpression instanceof ProgramExpressionBinary) {
            ProgramExpressionBinary binary = (ProgramExpressionBinary) binaryExpression;
            RValue left = binary.getLeft();
            RValue right = binary.getRight();
            SymbolType conversionType = SymbolTypeConversion.convertedNumberType(left, right, getScope(), currentStmt);
            if(conversionType != null) {
               // Convert both left and right to the found type
               SymbolType leftType = SymbolTypeInference.inferType(getProgram().getScope(), left);
               if(!leftType.equals(conversionType) && !(leftType instanceof SymbolTypePointer)) {
                  getLog().append("Adding number conversion cast (" + conversionType + ") " + binary.getLeft().toString() + " in " + (currentStmt==null?"":currentStmt.toString(getProgram(), false)));
                  binary.addLeftCast(conversionType, stmtIt, currentBlock==null?null:currentBlock.getScope(), getScope());
               }
               SymbolType rightType = SymbolTypeInference.inferType(getProgram().getScope(), right);
               if(!rightType.equals(conversionType) && !(rightType instanceof SymbolTypePointer)) {
                  getLog().append("Adding number conversion cast (" + conversionType + ") " + binary.getRight().toString() + " in " + ((currentStmt==null)?"":currentStmt.toString(getProgram(), false)));
                  binary.addRightCast(conversionType, stmtIt, currentBlock==null?null:currentBlock.getScope(), getScope());
               }
            }
         }
      });
      return false;
   }

}
