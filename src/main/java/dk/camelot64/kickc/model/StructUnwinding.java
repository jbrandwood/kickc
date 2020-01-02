package dk.camelot64.kickc.model;

import dk.camelot64.kickc.model.symbols.ArraySpec;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.symbols.StructDefinition;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.*;

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
   public VariableUnwinding createVariableUnwinding(SymbolVariableRef ref, StructDefinition structDefinition) {
      VariableUnwinding existing = structVariables.put(ref, new VariableUnwinding(structDefinition));
      if(existing != null) {
         throw new InternalError("ERROR! Struct unwinding was already created once! " + ref.toString());
      }
      return structVariables.get(ref);
   }


   /** Information about how a single struct variable was unwound. */
   public static class VariableUnwinding implements StructMemberUnwinding {

      StructDefinition structDefinition;

      /** Maps member names to the unwound variables. */
      Map<String, RValue> memberUnwinding;

      public VariableUnwinding(StructDefinition structDefinition) {
         this.structDefinition = structDefinition;
         memberUnwinding = new LinkedHashMap<>();
      }

      /** Set how a member variable was unwound to a specific (new) variable. */
      public void setMemberUnwinding(String memberName, RValue memberVariableUnwound) {
         this.memberUnwinding.put(memberName, memberVariableUnwound);
      }

      public List<String> getMemberNames() {
         return new ArrayList<>(memberUnwinding.keySet());
      }

      @Override
      public RValueUnwinding getMemberUnwinding(String memberName) {
         return new RValueUnwinding() {
            @Override
            public SymbolType getType() {
               return structDefinition.getMember(memberName).getType();
            }

            @Override
            public ArraySpec getArraySpec() {
               return structDefinition.getMember(memberName).getArraySpec();
            }

            @Override
            public RValue getUnwinding(ProgramScope programScope) {
               return memberUnwinding.get(memberName);
            }

            @Override
            public RValue getArrayUnwinding(ProgramScope scope, ConstantValue arraySize) {
               throw new RuntimeException("TODO: Implement!");
            }
         };
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
       * Get the RValue unwinding to use for copying a single member of the struct
       *
       * @param memberName The member name
       * @return The unwinding of the member
       */
      RValueUnwinding getMemberUnwinding(String memberName);

   }

   /**
    * Unwinding value used for copying a value from one variable to another.
    */
   public interface RValueUnwinding {

      /**
       * Get the type of the value
       * @return The type of the value
       */
      SymbolType getType();

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
       * Get Rvalue to use when for copying/setting an array value. Typically returns  memset/memcpy commands.
       * @param scope The program scope
       * @param arraySize The declared size of the array
       * @return The value to use as RValue
       */
      RValue getArrayUnwinding(ProgramScope scope, ConstantValue arraySize);

   }

}
