package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramExpressionIterator;
import dk.camelot64.kickc.model.iterator.ProgramExpressionUnary;
import dk.camelot64.kickc.model.operators.OperatorCast;
import dk.camelot64.kickc.model.types.*;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantPointer;
import dk.camelot64.kickc.model.values.RValue;

import java.util.concurrent.atomic.AtomicBoolean;

/** Simplifies casts
 * - Inlines casts of (number) constants
 * - Removes unnecessary casts
 * */
public class PassNCastSimplification extends Pass2SsaOptimization {

   public PassNCastSimplification(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      AtomicBoolean optimized = new AtomicBoolean(false);
      ProgramExpressionIterator.execute(getProgram(), (programExpression, currentStmt, stmtIt, currentBlock) -> {
         if(programExpression.getOperator() instanceof OperatorCast) {
            OperatorCast operatorCast = (OperatorCast) programExpression.getOperator();
            ProgramExpressionUnary unary = (ProgramExpressionUnary) programExpression;
            SymbolType castType = operatorCast.getToType();
            SymbolType operandType = SymbolTypeInference.inferType(getScope(), ((ProgramExpressionUnary) programExpression).getOperand());
            RValue unaryOperand = unary.getOperand();
            if(!SymbolTypeConversion.assignmentCastNeeded(castType, operandType)) {
               // Cast Not needed
               programExpression.set(unaryOperand);
               getLog().append("Simplifying constant integer cast " + unaryOperand.toString(getProgram()));
               optimized.set(true);
            } else if(unaryOperand instanceof ConstantInteger) {
               ConstantInteger constantInteger = (ConstantInteger) unaryOperand;
               if(SymbolType.NUMBER.equals(constantInteger.getType())) {
                  if(castType instanceof SymbolTypeIntegerFixed ) {
                     ConstantInteger newConstInt = new ConstantInteger(constantInteger.getInteger(), castType);
                     programExpression.set(newConstInt);
                     getLog().append("Simplifying constant integer cast " + newConstInt.toString());
                     optimized.set(true);
                  }  else if(castType instanceof SymbolTypePointer) {
                     ConstantPointer newConstPointer = new ConstantPointer(constantInteger.getInteger(), ((SymbolTypePointer) castType).getElementType());
                     programExpression.set(newConstPointer);
                     getLog().append("Simplifying constant pointer cast " + newConstPointer.toString());
                     optimized.set(true);
                  }
               } else if(castType instanceof SymbolTypeIntegerFixed) {
                  if(((SymbolTypeIntegerFixed) castType).contains(constantInteger.getValue())) {
                     // Cast type contains the value - cast not needed
                     ConstantInteger newConstInt = new ConstantInteger(constantInteger.getInteger(), castType);
                     programExpression.set(newConstInt);
                     getLog().append("Simplifying constant integer cast " + newConstInt.toString());
                     optimized.set(true);
                  }
               }
            }
         }
      });
      return optimized.get();
   }


}
