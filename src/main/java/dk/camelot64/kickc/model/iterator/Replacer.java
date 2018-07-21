package dk.camelot64.kickc.model.iterator;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.statements.Statement;

import java.util.ListIterator;

/** A replacer that receives a replaceable value and has the potential to replace the value or recurse into sub-values. */
public interface Replacer {
   /**
    * Execute replacement of a replaceable value.
    *
    * @param replaceable The replaceable value
    * @param currentStmt The statement iterator - just past the current statement that the value is a part of. Current statment can be retrieved by calling
    * @param stmtIt The statement iterator - just past the current statement. Can be used for modifying the control flow block.
    * @param currentBlock The current block that the value is a part of
    */
   void execute(ReplaceableValue replaceable, Statement currentStmt, ListIterator<Statement> stmtIt, ControlFlowBlock currentBlock);
}
