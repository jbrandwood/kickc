package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramExpressionBinary;
import dk.camelot64.kickc.model.iterator.ProgramExpressionIterator;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeArray;
import dk.camelot64.kickc.model.types.SymbolTypeConversion;
import dk.camelot64.kickc.model.types.SymbolTypeInference;
import dk.camelot64.kickc.model.values.*;

import java.util.ListIterator;
import java.util.concurrent.atomic.AtomicBoolean;

/**
 * Add casts to {@link SymbolType#NUMBER} expressions that are inside array initializers based on the type of the array
 */
public class PassNAddArrayNumberTypeConversions extends Pass2SsaOptimization {

   public PassNAddArrayNumberTypeConversions(Program program) {
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
            SymbolType leftType = SymbolTypeInference.inferType(getProgram().getScope(), left);
            if(leftType instanceof SymbolTypeArray && right instanceof ValueList) {
               SymbolType declaredElmType = ((SymbolTypeArray) leftType).getElementType();
               ListIterator<RValue> elmIterator = ((ValueList) right).getList().listIterator();
               while(elmIterator.hasNext()) {
                  RValue elm = elmIterator.next();
                  SymbolType elmType = SymbolTypeInference.inferType(getProgram().getScope(), elm);
                  if(SymbolType.NUMBER.equals(elmType)) {
                     // Add a cast - if the value fits.
                     if(!SymbolTypeConversion.assignmentTypeMatch(declaredElmType, elmType)) {
                        throw new CompileError("Array type " + declaredElmType + " does not match element type " + elmType , currentStmt);
                     }
                     // TODO: Test if the value matches the declared type!
                     if(elm instanceof ConstantValue) {
                        elmIterator.set(new ConstantCastValue(declaredElmType, (ConstantValue) elm));
                     }  else {
                        elmIterator.set(new CastValue(declaredElmType, elm));
                     }
                     modified.set(true);
                  }
               }
               if(modified.get()) {
                  getLog().append("Adding number conversion cast (" + declaredElmType+ ") to elements in " + (currentStmt == null ? "" : currentStmt.toString(getProgram(), false)));
               }
            }
         }
      });
      return modified.get();
   }

}
