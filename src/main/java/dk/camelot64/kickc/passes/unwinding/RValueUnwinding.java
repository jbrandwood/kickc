package dk.camelot64.kickc.passes.unwinding;

import dk.camelot64.kickc.model.symbols.ArraySpec;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.LValue;
import dk.camelot64.kickc.model.values.RValue;

/**
 * Assignment unwinding value used for copying one value to another using the most effective method.
 * Assignment uses typed copy for simple types. For arrays/struct values bulk-copying of memory is used when feasible and member-by-member copying when necessary.
 */
public interface RValueUnwinding {

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
    * Get the RValue to use in the assignment as LValue - and as RValue if the member is a not an array value
    *
    * @param programScope The program scope
    * @return The unwinding of the member
    */
   RValue getUnwinding(ProgramScope programScope);

   /**
    * Determine if the value can be bulk memory copied
    * @return true if the value can be bulk memory copied (from or to).
    */
   boolean isBulkCopyable();

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

}
