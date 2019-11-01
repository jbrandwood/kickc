package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeArray;
import dk.camelot64.kickc.model.values.*;

import java.util.Collection;

/**
 * Asserts that all arrays with lengths and initializers have matching lengths.
 */
public class Pass3AssertArrayLengths extends Pass2SsaAssertion {

   public Pass3AssertArrayLengths(Program program) {
      super(program);
   }

   @Override
   public void check() throws AssertionFailed {
      Collection<Variable> allConstants = getScope().getAllConstants(true);
      for(Variable constantVar : allConstants) {
         SymbolType constantType = constantVar.getType();
         if(constantType instanceof SymbolTypeArray) {
            RValue declaredSize = ((SymbolTypeArray) constantType).getSize();
            if(declaredSize != null) {
               if(!(declaredSize instanceof ConstantValue)) {
                  throw new CompileError("Error! Array declared size is not constant " + constantType.toString());
               }
               ConstantLiteral declaredSizeVal = ((ConstantValue) declaredSize).calculateLiteral(getScope());
               if(!(declaredSizeVal instanceof ConstantInteger)) {
                  throw new CompileError("Error! Array declared size is not integer " + constantType.toString());
               }
               Integer declaredSizeInt = ((ConstantInteger) declaredSizeVal).getInteger().intValue();
               // A constant size was found - Check that a value with the same size is present
               ConstantValue constantValue = constantVar.getConstantValue();
               if(constantValue == null) {
                  throw new CompileError("Error! Array with a size not initialized " + constantVar.toString(getProgram()));
               } else if(constantValue instanceof ConstantArrayFilled) {
                  ConstantValue assignedSize = ((ConstantArrayFilled) constantValue).getSize();
                  ConstantLiteral assignedSizeVal = assignedSize.calculateLiteral(getScope());
                  if(!(assignedSizeVal instanceof ConstantInteger)) {
                     throw new CompileError("Error! Array declared size is not integer " + constantType.toString());
                  }
                  Integer assignedSizeInt = ((ConstantInteger) declaredSizeVal).getInteger().intValue();
                  if(!assignedSizeInt.equals(declaredSizeInt)) {
                     throw new CompileError("Error! Array length mismatch " + constantVar.toString(getProgram()));
                  }
               } else if(constantValue instanceof ConstantArrayList) {
                  Integer assignedSizeVal = ((ConstantArrayList) constantValue).getElements().size();
                  if(assignedSizeVal > declaredSizeInt) {
                     throw new CompileError("Error! Array length mismatch " + constantVar.toString(getProgram()));
                  }
               } else if(constantValue instanceof ConstantArrayKickAsm) {
                  // KickAsm array initializer is assumed good!
               } else {
                  ConstantLiteral constantLiteral = constantValue.calculateLiteral(getScope());
                  if(constantLiteral instanceof ConstantString) {
                     Integer assignedSizeVal = ((ConstantString) constantLiteral).getStringLength();
                     if(assignedSizeVal > declaredSizeInt) {
                        throw new CompileError("Error! Array length mismatch " + constantVar.toString(getProgram()));
                     }
                  } else if(constantLiteral instanceof ConstantPointer) {
                     // Constant Pointers are OK for sized arrays
                  } else {
                     throw new AssertionFailed("Error! Array with a size unknown initialization value " + constantVar.toString(getProgram()));
                  }
               }
            }
         }
      }
   }

}
