package dk.camelot64.kickc.model;

import dk.camelot64.kickc.model.values.SymbolVariableRef;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Keeps track of all struct variables that have been unwound into member variables.
 */
public class StructVariableMemberUnwinding {

   /** Maps struct variables to unwinding of each member. */
   Map<SymbolVariableRef, VariableUnwinding> structVariables = new LinkedHashMap<>();

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
   public VariableUnwinding createVariableUnwinding(SymbolVariableRef ref) {
      VariableUnwinding existing = structVariables.put(ref, new VariableUnwinding());
      if(existing != null) {
         throw new InternalError("ERROR! Struct unwinding was already created once! " + ref.toString());
      }
      return structVariables.get(ref);
   }

   /** Information about how a single struct variable was unwound. */
   public static class VariableUnwinding {

      /** Maps member names to the unwound variables. */
      Map<String, SymbolVariableRef> memberUnwinding;

      public VariableUnwinding() {
         memberUnwinding = new LinkedHashMap<>();
      }

      /** Set how a member variable was unwound to a specific (new) variable. */
      public void setMemberUnwinding(String memberName, SymbolVariableRef memberVariableUnwound) {
         this.memberUnwinding.put(memberName, memberVariableUnwound);
      }

      public List<String> getMemberNames() {
         return new ArrayList<>(memberUnwinding.keySet());
      }

      public SymbolVariableRef getMemberUnwound(String memberName) {
         return memberUnwinding.get(memberName);
      }

   }

}
