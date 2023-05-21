package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.values.ConstantBinary;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantUnary;
import dk.camelot64.kickc.model.values.ConstantValue;

/**
 * Simplifies constant values
 * -  ++123 to 124
 * -  --123 to 122
 * -  x+0 to x
 * -  x*0 to 0
 */
public class Pass2ConstantSimplification extends Pass2SsaOptimization {

   public Pass2ConstantSimplification(Program program) {
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
               getLog().append("Simplifying constant integer increment " + unary);
               programValue.set(new ConstantInteger(intOperand.getValue() + 1, intOperand.getType()));
               optimized[0] = true;
            } else if(Operators.DECREMENT.equals(unary.getOperator()) && unary.getOperand() instanceof ConstantInteger) {
               // Found a candidate!!
               ConstantInteger intOperand = (ConstantInteger) unary.getOperand();
               getLog().append("Simplifying constant integer decrement " + unary);
               programValue.set(new ConstantInteger(intOperand.getValue() - 1, intOperand.getType()));
               optimized[0] = true;
            }
            if(Operators.INCREMENT.equals(unary.getOperator()) && unary.getOperand() instanceof ConstantBinary) {
               ConstantBinary binary = (ConstantBinary) unary.getOperand();
               if(binary.getRight() instanceof ConstantInteger && binary.getOperator().equals(Operators.PLUS)) {
                  // Found a candidate!!
                  ConstantInteger intOperand = (ConstantInteger) binary.getRight();
                  getLog().append("Simplifying constant integer increment " + unary);
                  programValue.set(new ConstantBinary(binary.getLeft(), Operators.PLUS, new ConstantInteger(intOperand.getValue() + 1, intOperand.getType())));
                  optimized[0] = true;
               } else {
                  ConstantValue subOperand = unary.getOperand();
                  // Found a nested increment (that does nest another increment)
                  getLog().append("Simplifying constant integer increment " + unary);
                  programValue.set(new ConstantBinary(subOperand, Operators.PLUS, new ConstantInteger(1L)));
                  optimized[0] = true;
               }
            }
            if(Operators.INCREMENT.equals(unary.getOperator()))
               if((unary.getOperand() instanceof ConstantUnary) && !Operators.INCREMENT.equals(((ConstantUnary) unary.getOperand()).getOperator())) {
                  ConstantValue subOperand = unary.getOperand();
                  // Found a nested increment (that does nest another increment)
                  getLog().append("Simplifying constant integer increment " + unary);
                  programValue.set(new ConstantBinary(subOperand, Operators.PLUS, new ConstantInteger(1L)));
                  optimized[0] = true;
               }
         } else if(programValue.get() instanceof ConstantBinary) {
            ConstantBinary binary = (ConstantBinary) programValue.get();
            if(Operators.MULTIPLY.equals(binary.getOperator())) {
               if(binary.getLeft() instanceof ConstantInteger && ((ConstantInteger) binary.getLeft()).getValue() == 0) {
                  getLog().append("Simplifying constant multiply by zero " + binary);
                  programValue.set(new ConstantInteger(0L, binary.getType(getProgramScope())));
               } else if(binary.getRight() instanceof ConstantInteger && ((ConstantInteger) binary.getRight()).getValue() == 0) {
                  getLog().append("Simplifying constant multiply by zero " + binary);
                  programValue.set(new ConstantInteger(0L, binary.getType(getProgramScope())));
               }
            } else if(Operators.PLUS.equals(binary.getOperator())) {
               if(binary.getLeft() instanceof ConstantInteger && ((ConstantInteger) binary.getLeft()).getValue() == 0) {
                  getLog().append("Simplifying constant plus zero " + binary);
                  programValue.set(binary.getRight());
               } else if(binary.getRight() instanceof ConstantInteger && ((ConstantInteger) binary.getRight()).getValue() == 0) {
                  getLog().append("Simplifying constant plus zero " + binary);
                  programValue.set(binary.getLeft());
               }
            }
         }
      });
      return optimized[0];
   }
}
