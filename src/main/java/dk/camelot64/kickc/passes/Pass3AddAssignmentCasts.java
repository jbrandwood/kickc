package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramExpressionBinary;
import dk.camelot64.kickc.model.iterator.ProgramExpressionIterator;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeConversion;
import dk.camelot64.kickc.model.types.SymbolTypeInference;

import java.util.concurrent.atomic.AtomicBoolean;

/**
 * Add casts to assignments where the lvalue and rvalue have different matching types.
 */
public class Pass3AddAssignmentCasts extends Pass2SsaOptimization {

   public Pass3AddAssignmentCasts(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      AtomicBoolean modified = new AtomicBoolean(false);
      ProgramExpressionIterator.execute(getProgram(), (programExpression, currentStmt, stmtIt, currentBlock) -> {
         if(programExpression instanceof ProgramExpressionBinary) {
            if(Operators.ASSIGNMENT.equals(programExpression.getOperator())) {
               ProgramExpressionBinary binary = (ProgramExpressionBinary) programExpression;
               SymbolType leftType = SymbolTypeInference.inferType(getScope(), binary.getLeft());
               SymbolType rightType = SymbolTypeInference.inferType(getScope(), binary.getRight());
               if(SymbolTypeConversion.assignmentTypeMatch(leftType, rightType) && SymbolTypeConversion.assignmentCastNeeded(leftType, rightType)) {
                  binary.addRightCast(leftType, stmtIt, currentBlock.getScope(), getScope());
                  getLog().append("Adding assignment cast to " + currentStmt.toString(getProgram(), false));
                  modified.set(true);
               }
            }
         }
      });
      return modified.get();
   }
}
