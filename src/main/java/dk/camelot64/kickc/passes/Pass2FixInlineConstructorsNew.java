package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.Comment;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramExpressionIterator;
import dk.camelot64.kickc.model.iterator.ProgramExpressionUnary;
import dk.camelot64.kickc.model.operators.OperatorBinary;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.symbols.Scope;
import dk.camelot64.kickc.model.symbols.VariableIntermediate;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.CastValue;
import dk.camelot64.kickc.model.values.RValue;
import dk.camelot64.kickc.model.values.ValueList;

import java.util.List;
import java.util.concurrent.atomic.AtomicBoolean;

/**
 * Identifies word constructors <code> (word) { b1, b2 }</code> and replaces
 * them with a binary operator <code>word w = b1 w= b2 ;</code>
 */
public class Pass2FixInlineConstructorsNew extends Pass2SsaOptimization {

   public Pass2FixInlineConstructorsNew(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      AtomicBoolean optimized = new AtomicBoolean(false);
      ProgramExpressionIterator.execute(getProgram(), (programExpression, currentStmt, stmtIt, currentBlock) -> {
         if(programExpression instanceof ProgramExpressionUnary) {
            if(programExpression.getOperator().equals(Operators.CAST_WORD)) {
               if(((ProgramExpressionUnary) programExpression).getOperand() instanceof ValueList) {
                  ValueList list = (ValueList) ((ProgramExpressionUnary) programExpression).getOperand();
                  List<RValue> listValues = list.getList();
                  if(listValues.size()==2) {

                     OperatorBinary constructOperator = Operators.WORD;
                     SymbolType constructType = SymbolType.WORD;

                     // Convert list to a word constructor in a new tmp variable
                     Scope currentScope = Pass2FixInlineConstructorsNew.this.getScope().getScope(currentBlock.getScope());
                     VariableIntermediate tmpVar = currentScope.addVariableIntermediate();
                     tmpVar.setTypeInferred(constructType);
                     // Move backward - to insert before the current statement
                     stmtIt.previous();
                     // Add assignment of the new tmpVar
                     StatementAssignment assignment = new StatementAssignment(tmpVar.getRef(), new CastValue(SymbolType.BYTE, listValues.get(0)), constructOperator, new CastValue(SymbolType.BYTE, listValues.get(1)), currentStmt.getSource(), Comment.NO_COMMENTS);
                     stmtIt.add(assignment);
                     // Move back before the current statement
                     stmtIt.next();
                     // Replace current value with the reference
                     programExpression.set(tmpVar.getRef());
                     Pass2FixInlineConstructorsNew.this.getLog().append("Fixing inline constructor with " + assignment.toString());
                     optimized.set(true);
                  }
               }
            }
         }
      });
      return optimized.get();

   }


}
