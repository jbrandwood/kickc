package dk.camelot64.kickc.passes.unwinding;

import dk.camelot64.kickc.model.symbols.ProgramScope;

import java.util.List;

/** Assignment unwinding information for a struct value into separate members. */
public interface StructUnwinding {

   /**
    * Get the names of the members of the struct
    *
    * @return the names
    */
   List<String> getMemberNames();

   /**
    * Get the RValue unwinding to use for copying a single member of the struct
    *
    * @param memberName The member name
    * @param programScope
    * @return The unwinding of the member
    */
   RValueUnwinding getMemberUnwinding(String memberName, ProgramScope programScope);

}
