package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.Comment;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.VariableBuilder;
import dk.camelot64.kickc.model.iterator.ProgramExpressionBinary;
import dk.camelot64.kickc.model.iterator.ProgramExpressionIterator;
import dk.camelot64.kickc.model.iterator.ProgramValue;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.symbols.Scope;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.CastValue;

import java.util.ListIterator;

/**
 * Turn CastValues that are part of complex expressions into intermediate variables
 */
public class PassNDeInlineCastValues extends Pass2SsaOptimization {

   private boolean pass1;

   public PassNDeInlineCastValues(Program program, boolean pass1) {
      super(program);
      this.pass1 = pass1;
   }

   @Override
   public boolean step() {
      ProgramExpressionIterator.execute(getProgram(), (programExpression, currentStmt, stmtIt, currentBlock) -> {
         if(programExpression instanceof ProgramExpressionBinary) {
            final ProgramExpressionBinary expressionBinary = (ProgramExpressionBinary) programExpression;
            if(expressionBinary.getLeft() instanceof CastValue && !Operators.ASSIGNMENT.equals(expressionBinary.getOperator())) {
               final ProgramValue castProgramValue = ((ProgramExpressionBinary) programExpression).getLeftValue();
               deInlineCastValue(castProgramValue, stmtIt, currentBlock, currentStmt);
            }
            if(expressionBinary.getRight() instanceof CastValue && !Operators.ASSIGNMENT.equals(expressionBinary.getOperator())) {
               final ProgramValue castProgramValue = ((ProgramExpressionBinary) programExpression).getRightValue();
               deInlineCastValue(castProgramValue, stmtIt, currentBlock, currentStmt);
            }
         }
      });
      return false;
   }

   private void deInlineCastValue(ProgramValue castProgramValue, ListIterator<Statement> stmtIt, ControlFlowBlock currentBlock, Statement currentStmt) {
      final CastValue castValue = (CastValue) castProgramValue.get();
      if(!pass1)
         getLog().append("De-inlining cast " + castValue.toString());
      final Scope scope = getScope().getScope(currentBlock.getScope());
      SymbolType toType = castValue.getToType();
      final Variable tmpVar = VariableBuilder.createIntermediate(scope, toType, getProgram());
      castProgramValue.set(tmpVar.getRef());
      stmtIt.previous();
      stmtIt.add(new StatementAssignment(tmpVar.getVariableRef(), castValue, true, currentStmt.getSource(), Comment.NO_COMMENTS));
      stmtIt.next();
   }

}
