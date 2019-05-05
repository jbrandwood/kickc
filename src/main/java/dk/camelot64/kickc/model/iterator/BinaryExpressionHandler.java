package dk.camelot64.kickc.model.iterator;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.statements.Statement;

import java.util.ListIterator;

/** A handler that performs some action for binary expressions in the program.
 *  A {@link BinaryExpressionIterator} can be used to iterate all binary expressions in a part of the program.
 *  The Handler then receives all binary expressions one at a time. The Handler has the option of modifying the binary expression. After the handler is executed all sub-values are recursed.
 *  The execute() method furthermore receives some extra parameters with information about the context of the passed value.
 */
public interface BinaryExpressionHandler {

   /**
    * Handle a single binary expression
    *
    * @param binaryExpression The binary expression
    * @param currentStmt The statement iterator - just past the current statement that the value is a part of. Current statment can be retrieved by calling
    * @param stmtIt The statement iterator - just past the current statement. Can be used for modifying the control flow block.
    * @param currentBlock The current block that the value is a part of
    */
   void execute(BinaryExpression binaryExpression, Statement currentStmt, ListIterator<Statement> stmtIt, ControlFlowBlock currentBlock);

}
