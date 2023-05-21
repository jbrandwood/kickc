package dk.camelot64.kickc.model.iterator;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Graph;
import dk.camelot64.kickc.model.statements.Statement;

import java.util.ListIterator;

/** A handler that performs some action for unary/binary expressions in the program.
 *  A {@link ProgramExpressionIterator} can be used to iterate all unary/binary expressions in a part of the program.
 *  The Handler then receives all unary/binary expressions one at a time.
 *  The Handler has the option of modifying the expression. After the handler is executed all sub-values are recursed.
 *  The execute() method furthermore receives some extra parameters with information about the context of the passed value.
 */
public interface ProgramExpressionHandler {

   /**
    * Handle a single expression
    *
    * @param programExpression The expression
    * @param currentStmt The statement iterator - just past the current statement that the value is a part of. Current statment can be retrieved by calling
    * @param stmtIt The statement iterator - just past the current statement. Can be used for modifying the control flow block.
    * @param currentBlock The current block that the value is a part of
    */
   void execute(ProgramExpression programExpression, Statement currentStmt, ListIterator<Statement> stmtIt, Graph.Block currentBlock);

}
