package dk.camelot64.kickc.passes.unwinding;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.symbols.ArraySpec;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.LValue;
import dk.camelot64.kickc.model.values.RValue;

import java.util.List;
import java.util.ListIterator;

/**
 * A value that is either the source or destination of a copy operation.
 * Handles unwinding of struct copying when needed. Supports bulk copying.
 */
public interface ValueSource {

   /**
    * Determine if the value can be simple copied
    * @return true if the value is a simple value (not an array or a struct value
    */
   boolean isSimple();

   /**
    * Determine if the value can be bulk memory copied
    * @return true if the value can be bulk memory copied (from or to).
    */
   boolean isBulkCopyable();

   /**
    * Determine if the value can be unwound to sub-values
    * @return true if the value is a struct value
    */
   boolean isUnwindable();

   /**
    * Get the type of the value
    * @return The type of the value
    */
   SymbolType getSymbolType();

   /**
    * Get the array nature of the value
    * @return The array nature of the value
    */
   ArraySpec getArraySpec();

   /**
    * Get the simple value to use when performing a simple copy
    *
    * @param programScope The program scope
    * @return The unwinding of the member
    */
   RValue getSimpleValue(ProgramScope programScope);

   /**
    * Get Lvalue to use when for copying/setting a bulk value at once. Must returns a byte* type.
    * @param scope The program scope
    * @return The value to use as RValue
    */
   LValue getBulkLValue(ProgramScope scope);

   /**
    * Get Rvalue to use when for copying/setting a bulk value at once. Typically returns a memset/memcpy command.
    * @param scope The program scope
    * @return The value to use as RValue
    */
   RValue getBulkRValue(ProgramScope scope);

   /**
    * Get the names of the members of the struct (if the value is an unwindable struct)
    *
    * @return the names
    */
   List<String> getMemberNames(ProgramScope scope);

   /**
    * Get a sub value source for one member to use for copying that member.
    *
    * @param memberName The member name
    * @param program
    * @param programScope The program scope
    * @param currentStmt
    * @param currentBlock
    * @param stmtIt
    * @return The unwinding of the member
    */
   ValueSource getMemberUnwinding(String memberName, Program program, ProgramScope programScope, Statement currentStmt, ControlFlowBlock currentBlock, ListIterator<Statement> stmtIt);

}
