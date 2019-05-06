package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramExpressionIterator;
import dk.camelot64.kickc.model.iterator.ProgramExpressionUnary;
import dk.camelot64.kickc.model.operators.OperatorCast;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeIntegerFixed;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantPointer;

import java.util.concurrent.atomic.AtomicBoolean;

/** Simplifies casts of (number) constants to a type. */
public class Pass2ConstantCastSimplification extends Pass2SsaOptimization {

   public Pass2ConstantCastSimplification(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      AtomicBoolean optimized = new AtomicBoolean(false);
      ProgramExpressionIterator.execute(getProgram(), (programExpression, currentStmt, stmtIt, currentBlock) -> {
         if(programExpression.getOperator() instanceof OperatorCast) {
            OperatorCast operatorCast = (OperatorCast) programExpression.getOperator();
            ProgramExpressionUnary unary = (ProgramExpressionUnary) programExpression;
            if(unary.getOperand() instanceof ConstantInteger) {
               ConstantInteger constantInteger = (ConstantInteger) unary.getOperand();
               if(constantInteger.getType().equals(SymbolType.NUMBER)) {
                  SymbolType castType = operatorCast.getToType();
                  if(castType instanceof SymbolTypeIntegerFixed ) {
                     ConstantInteger newConstInt = new ConstantInteger(constantInteger.getInteger(), castType);
                     programExpression.set(newConstInt);
                     getLog().append("Simplifying constant integer cast " + newConstInt.toString());
                  }  else if(castType instanceof SymbolTypePointer) {
                     ConstantPointer newConstPointer = new ConstantPointer(constantInteger.getInteger(), ((SymbolTypePointer) castType).getElementType());
                     programExpression.set(newConstPointer);
                     getLog().append("Simplifying constant pointer cast " + newConstPointer.toString());
                  }
               }
            }
         }
      });
      return optimized.get();
   }


}
