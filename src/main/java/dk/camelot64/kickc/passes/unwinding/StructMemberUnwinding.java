package dk.camelot64.kickc.passes.unwinding;

import java.util.List;

/** Assignment unwinding information for a struct value into separate members. */
public interface StructMemberUnwinding {

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
    * @return The unwinding of the member
    */
   RValueUnwinding getMemberUnwinding(String memberName);

}
