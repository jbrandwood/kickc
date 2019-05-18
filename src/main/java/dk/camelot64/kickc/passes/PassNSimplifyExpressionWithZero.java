package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramExpressionBinary;
import dk.camelot64.kickc.model.iterator.ProgramExpressionIterator;
import dk.camelot64.kickc.model.operators.Operator;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.PointerDereferenceSimple;
import dk.camelot64.kickc.model.values.RValue;

import java.util.concurrent.atomic.AtomicBoolean;

/**
 * Simplify any binary expression containing a zero value (if possible
 */
public class PassNSimplifyExpressionWithZero extends Pass2SsaOptimization {

   public PassNSimplifyExpressionWithZero(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      AtomicBoolean modified = new AtomicBoolean(false);

      ProgramExpressionIterator.execute(getProgram(), (programExpression, currentStmt, stmtIt, currentBlock) -> {
         if(programExpression instanceof ProgramExpressionBinary) {
            ProgramExpressionBinary binary = (ProgramExpressionBinary) programExpression;
            RValue left = binary.getLeft();
            RValue right = binary.getRight();
            Operator operator = programExpression.getOperator();
            if(Operators.PLUS.equals(operator) || Operators.MINUS.equals(operator) || Operators.BOOL_OR.equals(operator) || Operators.BOOL_XOR.equals(operator)) {
               if(left instanceof ConstantInteger && ((ConstantInteger) left).getInteger() == 0) {
                  getLog().append("Simplifying expression containing zero " + binary.getRight().toString()+ " in "+ (currentStmt==null?"":currentStmt.toString(getProgram(), false)));
                  if(programExpression instanceof ProgramExpressionBinary.ProgramExpressionBinaryPointerDereferenceIndexed) {
                     programExpression.set(new PointerDereferenceSimple(binary.getRight()));
                  }  else {
                     programExpression.set(binary.getRight());
                  }
                  modified.set(true);
               } else if(right instanceof ConstantInteger && ((ConstantInteger) right).getInteger() == 0) {
                  getLog().append("Simplifying expression containing zero " + binary.getLeft().toString()+ " in "+ (currentStmt==null?"":currentStmt.toString(getProgram(), false)));
                  if(programExpression instanceof ProgramExpressionBinary.ProgramExpressionBinaryPointerDereferenceIndexed) {
                     programExpression.set(new PointerDereferenceSimple(binary.getLeft()));
                  }  else {
                     programExpression.set(binary.getLeft());
                  }
                  modified.set(true);
               }
            }
         }
      });

      return modified.get();
   }

}
