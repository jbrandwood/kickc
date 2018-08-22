package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantUnary;

/** Optimizes constants number++ to the number plus one (replacing a ConstantUnary with a ConstantInteger)*/
public class Pass2ConstantIntIncrementConsolidation extends Pass2SsaOptimization {

   public Pass2ConstantIntIncrementConsolidation(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      final boolean[] optimized = {false};
      ProgramValueIterator.execute(getProgram(), (programValue, currentStmt, stmtIt, currentBlock) -> {
         if(programValue.get() instanceof ConstantUnary) {
            ConstantUnary unary = (ConstantUnary) programValue.get();
            if(Operators.INCREMENT.equals(unary.getOperator()) && unary.getOperand() instanceof ConstantInteger) {
               // Found a candidate!!
               ConstantInteger intOperand = (ConstantInteger) unary.getOperand();
               getLog().append("Optimizing constant integer increment "+unary);
               programValue.set(new ConstantInteger(intOperand.getValue()+1));
               optimized[0] = true;
            } else if(Operators.DECREMENT.equals(unary.getOperator()) && unary.getOperand() instanceof ConstantInteger) {
               // Found a candidate!!
               ConstantInteger intOperand = (ConstantInteger) unary.getOperand();
               getLog().append("Optimizing constant integer decrement "+unary);
               programValue.set(new ConstantInteger(intOperand.getValue()+1));
               optimized[0] = true;
            }
         }
      });
      return optimized[0];
   }
}
