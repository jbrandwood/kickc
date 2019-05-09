package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramExpressionBinary;
import dk.camelot64.kickc.model.iterator.ProgramExpressionIterator;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeInference;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.values.*;

import java.util.concurrent.atomic.AtomicBoolean;

/**
 * Downgrade any number expression cast that are part of a WORD+NUMBER expression to BYTE if the number is small enough to fit in the byte.
 */
public class PassNDowngradeBytePlusWord extends Pass2SsaOptimization {

   public PassNDowngradeBytePlusWord(Program program) {
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
            if(isConstantWord(left) && isWordLike(right) && isByteLike((ConstantValue) left)) {
               getLog().append("Downgrading number conversion cast to (byte) " + binary.getLeft().toString() + " in " + (currentStmt == null ? "" : currentStmt.toString(getProgram(), false)));
               binary.addLeftCast(SymbolType.BYTE, stmtIt, currentBlock == null ? null : currentBlock.getScope(), getScope());
               modified.set(true);
            } else if(isConstantWord(right) && isWordLike(left) && isByteLike((ConstantValue) right)) {
               getLog().append("Downgrading number conversion cast to (byte) " + binary.getRight().toString() + " in " + (currentStmt == null ? "" : currentStmt.toString(getProgram(), false)));
               binary.addRightCast(SymbolType.BYTE, stmtIt, currentBlock == null ? null : currentBlock.getScope(), getScope());
               modified.set(true);
            }

         }
      });
      return modified.get();
   }


   /**
    * Determines if a constant value is a byte-like value (can be represented inside a BYTE)
    *
    * @param constantValue The value to examine
    * @return true if the value is a byte-like value
    */
   public boolean isByteLike(ConstantValue constantValue) {
      ConstantLiteral constantLiteral = (constantValue).calculateLiteral(getScope());
      if(constantLiteral instanceof ConstantInteger) {
         ConstantInteger constantInteger = (ConstantInteger) constantLiteral;
         Long value = constantInteger.getValue();
         if(SymbolType.BYTE.contains(value)) {
            return true;
         }
      }
      return false;
   }

   /**
    * Determines if a value is a word-like value (WORD or Pointer)
    *
    * @param rValue The value to examine
    * @return true if the value is a word-like value
    */
   public boolean isWordLike(RValue rValue) {
      SymbolType symbolType = SymbolTypeInference.inferType(getProgram().getScope(), rValue);
      return symbolType.equals(SymbolType.WORD) || symbolType instanceof SymbolTypePointer;
   }


   /**
    * Determines if the passed value is a constant cast to WORD
    *
    * @param rValue The value to examine
    * @return true if the value is a constant cast to word
    */
   public boolean isConstantWord(RValue rValue) {
      if(rValue instanceof ConstantInteger && ((ConstantInteger) rValue).getType().equals(SymbolType.WORD)) {
         return true;
      }
      if((rValue instanceof ConstantCastValue) && ((ConstantCastValue) rValue).getToType().equals(SymbolType.WORD))
         return true;
      return false;
   }

}
