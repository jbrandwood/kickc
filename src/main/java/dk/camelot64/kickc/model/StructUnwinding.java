package dk.camelot64.kickc.model;

import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.RValue;
import dk.camelot64.kickc.model.values.SymbolVariableRef;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Keeps track of all struct variables that have been unwound into member variables.
 */
public class StructUnwinding {

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
   public static class VariableUnwinding implements StructMemberUnwinding {

      /** Maps member names to the unwound variables. */
      Map<String, RValue> memberUnwinding = new LinkedHashMap<>();

      /** Maps member names to the unwound variable types. */
      Map<String, SymbolType> typesUnwinding = new LinkedHashMap<>();

      /** Set how a member variable was unwound to a specific (new) variable. */
      public void setMemberUnwinding(String memberName, RValue memberVariableUnwound, SymbolType memberType) {
         this.memberUnwinding.put(memberName, memberVariableUnwound);
         this.typesUnwinding.put(memberName, memberType);
      }

      public List<String> getMemberNames() {
         return new ArrayList<>(memberUnwinding.keySet());
      }

      public RValue getMemberUnwinding(String memberName, ProgramScope programScope) {
         return this.memberUnwinding.get(memberName);
      }

      @Override
      public SymbolType getMemberType(String memberName) {
         return this.typesUnwinding.get(memberName);
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
       * Get the RValue that a specific member was unwound to
       *
       * @param memberName The member name
       * @param programScope The program scope
       * @return The unwinding of the member
       */
      RValue getMemberUnwinding(String memberName, ProgramScope programScope);

      /**
       * Get the type of a specific member
       * @param memberName The name of the struct member
       * @return The type of the member
       */
      SymbolType getMemberType(String memberName);
   }
}
