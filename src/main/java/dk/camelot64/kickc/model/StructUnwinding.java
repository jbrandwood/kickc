package dk.camelot64.kickc.model;

import dk.camelot64.kickc.model.values.LValue;
import dk.camelot64.kickc.model.values.SymbolVariableRef;
import dk.camelot64.kickc.model.values.VariableRef;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Keeps track of all struct variables that have been unwound into member variables.
 */
public class StructUnwinding {

   /** Maps struct variables to unwinding of each member. */
   Map<VariableRef, VariableUnwinding> structVariables = new LinkedHashMap<>();

   /**
    * Get information about how a struct variable was unwound into member variables
    *
    * @param ref The variable to look for
    * @return Information about the unwinding. Null if not unwound
    */
   public VariableUnwinding getVariableUnwinding(SymbolVariableRef ref) {
      return structVariables.get(ref);
   }

   /**
    * Add information about how a struct variable was unwound into member variables
    *
    * @param ref The variable to add information for
    * @return The new information about the unwinding.
    */
   public VariableUnwinding createVariableUnwinding(VariableRef ref) {
      VariableUnwinding existing = structVariables.put(ref, new VariableUnwinding());
      if(existing != null) {
         throw new InternalError("ERROR! Struct unwinding was already created once! " + ref.toString());
      }
      return structVariables.get(ref);
   }


   /** Information about how a single struct variable was unwound. */
   public static class VariableUnwinding implements StructMemberUnwinding {

      /** Maps member names to the unwound variables. */
      Map<String, VariableRef> memberUnwinding = new LinkedHashMap<>();

      /** Set how a member variable was unwound to a specific (new) variable. */
      public void setMemberUnwinding(String memberName, VariableRef memberVariableUnwound) {
         this.memberUnwinding.put(memberName, memberVariableUnwound);
      }

      /**
       * Get the names of the members of the struct
       *
       * @return the names
       */
      public List<String> getMemberNames() {
         return new ArrayList<>(memberUnwinding.keySet());
      }

      /**
       * Get the (new) variable that a specific member was unwound to
       *
       * @param memberName The member name
       * @return The new variable
       */
      public LValue getMemberUnwinding(String memberName) {
         return this.memberUnwinding.get(memberName);
      }
   }

   /** Information about how members of an struct Lvalue is unwound. */
   public interface StructMemberUnwinding {

      /**
       * Get the names of the members of the struct
       *
       * @return the names
       */
      List<String> getMemberNames();

      /**
       * Get the LValue that a specific member was unwound to
       *
       * @param memberName The member name
       * @return The unwinding of the member
       */
      LValue getMemberUnwinding(String memberName);
   }
}
