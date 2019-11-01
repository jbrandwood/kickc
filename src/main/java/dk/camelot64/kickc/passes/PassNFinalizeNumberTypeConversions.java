package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.InternalError;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeConversion;
import dk.camelot64.kickc.model.values.ConstantCastValue;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;
import dk.camelot64.kickc.model.values.ConstantRef;

import java.util.concurrent.atomic.AtomicBoolean;

/**
 * Finalize any constant integers to the smallest fixed size signed/unsigned type - if they have been resolved as snumber/unumber.
 */
public class PassNFinalizeNumberTypeConversions extends Pass2SsaOptimization {

   public PassNFinalizeNumberTypeConversions(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      AtomicBoolean modified = new AtomicBoolean(false);
      ProgramValueIterator.execute(getProgram(), (programValue, currentStmt, stmtIt, currentBlock) -> {
         if(programValue.get() instanceof ConstantInteger) {
            ConstantInteger constantInteger = (ConstantInteger) programValue.get();
            if(SymbolType.UNUMBER.equals(constantInteger.getType())) {
               SymbolType integerType = SymbolTypeConversion.getSmallestUnsignedFixedIntegerType(constantInteger, getScope());
               programValue.set(new ConstantInteger(constantInteger.getValue(), integerType));
               getLog().append("Finalized unsigned number type "+programValue.get().toString(getProgram()));
               modified.set(true);
            } else  if(SymbolType.SNUMBER.equals(constantInteger.getType())) {
               SymbolType integerType = SymbolTypeConversion.getSmallestSignedFixedIntegerType(constantInteger, getScope());
               programValue.set(new ConstantInteger(constantInteger.getValue(), integerType));
               getLog().append("Finalized signed number type "+programValue.get().toString(getProgram()));
               modified.set(true);
            }
         } else if(programValue.get() instanceof ConstantCastValue) {
            ConstantCastValue constantCastValue = (ConstantCastValue) programValue.get();
            SymbolType toType = constantCastValue.getToType();
            if(SymbolType.UNUMBER.equals(toType)) {
               if(constantCastValue.getValue() instanceof ConstantRef) {
                  ConstantRef constRef = (ConstantRef) constantCastValue.getValue();
                  Variable constant = getScope().getConstant(constRef);
                  if(constant.isInferredType())
                     constant.setTypeInferred(toType);
                  else
                     throw new InternalError("Cannot cast declared type!" + constant.toString());
               } else {
                  ConstantLiteral constantLiteral = constantCastValue.getValue().calculateLiteral(getProgram().getScope());
                  SymbolType smallestUnsigned = SymbolTypeConversion.getSmallestUnsignedFixedIntegerType(constantLiteral, getScope());
                  if(smallestUnsigned!=null) {
                     constantCastValue.setToType(smallestUnsigned);
                  }
               }
            } else if(SymbolType.SNUMBER.equals(toType)) {
               if(constantCastValue.getValue() instanceof ConstantRef) {
                  ConstantRef constRef = (ConstantRef) constantCastValue.getValue();
                  Variable constant = getScope().getConstant(constRef);
                  if(constant.isInferredType())
                     constant.setTypeInferred(toType);
                  else
                     throw new InternalError("Cannot cast declared type!" + constant.toString());
               } else {
                  ConstantLiteral constantLiteral = constantCastValue.getValue().calculateLiteral(getProgram().getScope());
                  SymbolType smallestSigned = SymbolTypeConversion.getSmallestSignedFixedIntegerType(constantLiteral, getScope());
                  if(smallestSigned!=null) {
                     constantCastValue.setToType(smallestSigned);
                  }
               }
            }
         }
      });
      return modified.get();
   }

}
