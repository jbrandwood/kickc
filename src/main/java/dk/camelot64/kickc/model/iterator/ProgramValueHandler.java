package dk.camelot64.kickc.model.iterator;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Graph;
import dk.camelot64.kickc.model.statements.Statement;

import java.util.ListIterator;

/** A handler that performs some action for RValues in the program.
 *  A {@link }ProgramValueIterator} can be used to iterate all RValues in a part of the program.
 *  The Handler then receives all program values one at a time. The Handler has the option of replacing the value with another. After the handler is executed all sub-values are recursed.
 *  The execute() method furthermore receives some extra parameters with information about the context of the passed value.
 */
public interface ProgramValueHandler {
   /**
    * Handle a single RValue
    *
    * @param programValue The programValue value
    * @param currentStmt The statement iterator - just past the current statement that the value is a part of. Current statment can be retrieved by calling
    * @param stmtIt The statement iterator - just past the current statement. Can be used for modifying the control flow block.
    * @param currentBlock The current block that the value is a part of
    */
   void execute(ProgramValue programValue, Statement currentStmt, ListIterator<Statement> stmtIt, Graph.Block currentBlock);

}
