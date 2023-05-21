package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ConstantNotLiteral;
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

   /** True if NUMBERS should also be finalized to the smallest fixed integer type that can hold it. */
   private boolean finalizeAllNumbers;

   public PassNFinalizeNumberTypeConversions(Program program, boolean finalizeAllNumbers) {
      super(program);
      this.finalizeAllNumbers = finalizeAllNumbers;
   }

   @Override
   public boolean step() {
      AtomicBoolean modified = new AtomicBoolean(false);
      ProgramValueIterator.execute(getProgram(), (programValue, currentStmt, stmtIt, currentBlock) -> {
         if(programValue.get() instanceof ConstantInteger) {
            ConstantInteger constantInteger = (ConstantInteger) programValue.get();
            if(SymbolType.UNUMBER.equals(constantInteger.getType())) {
               SymbolType integerType = SymbolTypeConversion.getSmallestUnsignedFixedIntegerType(constantInteger, getProgramScope());
               programValue.set(new ConstantInteger(constantInteger.getValue(), integerType));
               getLog().append("Finalized unsigned number type (" + integerType + ") " + programValue.get().toString(getProgram()));
               modified.set(true);
            } else if(SymbolType.SNUMBER.equals(constantInteger.getType())) {
               SymbolType integerType = SymbolTypeConversion.getSmallestSignedFixedIntegerType(constantInteger, getProgramScope());
               programValue.set(new ConstantInteger(constantInteger.getValue(), integerType));
               getLog().append("Finalized signed number type (" + integerType + ") " + programValue.get().toString(getProgram()));
               modified.set(true);
            } else if(finalizeAllNumbers && SymbolType.NUMBER.equals(constantInteger.getType()) && constantInteger.getValue() >= 0) {
               SymbolType integerType = SymbolTypeConversion.getSmallestUnsignedFixedIntegerType(constantInteger, getProgramScope());
               programValue.set(new ConstantInteger(constantInteger.getValue(), integerType));
               getLog().append("Finalized unsigned number type (" + integerType + ") " + programValue.get().toString(getProgram()));
               modified.set(true);
            } else if(finalizeAllNumbers && SymbolType.NUMBER.equals(constantInteger.getType()) && constantInteger.getValue() <= 0) {
               SymbolType integerType = SymbolTypeConversion.getSmallestSignedFixedIntegerType(constantInteger, getProgramScope());
               programValue.set(new ConstantInteger(constantInteger.getValue(), integerType));
               getLog().append("Finalized signed number type (" + integerType + ") " + programValue.get().toString(getProgram()));
               modified.set(true);
            }
         } else if(programValue.get() instanceof ConstantCastValue) {
            ConstantCastValue constantCastValue = (ConstantCastValue) programValue.get();
            SymbolType toType = constantCastValue.getToType();
            if(SymbolType.UNUMBER.equals(toType)) {
               if(constantCastValue.getValue() instanceof ConstantRef) {
                  ConstantRef constRef = (ConstantRef) constantCastValue.getValue();
                  Variable constant = getProgramScope().getConstant(constRef);
                  if(constant.isKindIntermediate())
                     constant.setType(toType);
                  else
                     throw new InternalError("Cannot cast declared type!" + constant.toString());
               } else {
                  ConstantLiteral constantLiteral;
                  try {
                     constantLiteral = constantCastValue.getValue().calculateLiteral(getProgram().getScope());
                  } catch (ConstantNotLiteral e) {
                     throw new InternalError("Cannot cast declared type!" + constantCastValue.toString());
                  }
                  SymbolType smallestUnsigned = SymbolTypeConversion.getSmallestUnsignedFixedIntegerType(constantLiteral, getProgramScope());
                  if(smallestUnsigned != null) {
                     constantCastValue.setToType(smallestUnsigned);
                  }
               }
            } else if(SymbolType.SNUMBER.equals(toType)) {
               if(constantCastValue.getValue() instanceof ConstantRef) {
                  ConstantRef constRef = (ConstantRef) constantCastValue.getValue();
                  Variable constant = getProgramScope().getConstant(constRef);
                  if(constant.isKindIntermediate())
                     constant.setType(toType);
                  else
                     throw new InternalError("Cannot cast declared type!" + constant.toString());
               } else {
                  ConstantLiteral constantLiteral = constantCastValue.getValue().calculateLiteral(getProgram().getScope());
                  SymbolType smallestSigned = SymbolTypeConversion.getSmallestSignedFixedIntegerType(constantLiteral, getProgramScope());
                  if(smallestSigned != null) {
                     constantCastValue.setToType(smallestSigned);
                  }
               }
            }
         }
      });
      return modified.get();
   }

}
