package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramExpressionBinary;
import dk.camelot64.kickc.model.iterator.ProgramExpressionIterator;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeConversion;
import dk.camelot64.kickc.model.types.SymbolTypeInference;
import dk.camelot64.kickc.model.values.RValue;

import java.util.concurrent.atomic.AtomicBoolean;

/**
 * Add casts to {@link SymbolType#NUMBER} expressions that meet a typed value in a binary expression (including assignment)
 */
public class PassNAddNumberTypeConversions extends Pass2SsaOptimization {

   public PassNAddNumberTypeConversions(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      AtomicBoolean modified = new AtomicBoolean(false);
      ProgramExpressionIterator.execute(getProgram(), (binaryExpression, currentStmt, stmtIt, currentBlock) -> {
         if(binaryExpression instanceof ProgramExpressionBinary) {
            ProgramExpressionBinary binary = (ProgramExpressionBinary) binaryExpression;
            RValue left = binary.getLeft();
            RValue right = binary.getRight();
            SymbolType castType = SymbolTypeConversion.getNumberCastType(left, right, getProgramScope(), currentStmt);
            if(castType != null) {
               // Convert both left and right to the found type
               SymbolType leftType = SymbolTypeInference.inferType(getProgram().getScope(), left);
               if(SymbolType.NUMBER.equals(leftType)) {
                  getLog().append("Adding number conversion cast (" + castType + ") " + binary.getLeft().toString() + " in " + (currentStmt==null?"":currentStmt.toString(getProgram(), false)));
                  binary.addLeftCast(castType, stmtIt, currentBlock==null?null:currentBlock.getScope(), getProgram());
                  modified.set(true);
               }
               SymbolType rightType = SymbolTypeInference.inferType(getProgram().getScope(), right);
               if(SymbolType.NUMBER.equals(rightType)) {
                  getLog().append("Adding number conversion cast (" + castType + ") " + binary.getRight().toString() + " in " + ((currentStmt==null)?"":currentStmt.toString(getProgram(), false)));
                  binary.addRightCast(castType, stmtIt, currentBlock==null?null:currentBlock.getScope(), getProgram());

                  modified.set(true);
               }
            }
         }
      });
      return modified.get();
   }

}
