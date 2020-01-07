package dk.camelot64.kickc.model;

import dk.camelot64.kickc.model.symbols.ArraySpec;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.symbols.StructDefinition;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeStruct;
import dk.camelot64.kickc.model.values.*;
import dk.camelot64.kickc.passes.unwinding.RValueUnwinding;
import dk.camelot64.kickc.passes.unwinding.StructMemberUnwinding;

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
            public SymbolType getSymbolType() {
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
            public boolean isBulkCopyable() {
               return getArraySpec()!=null;
            }

            @Override
            public LValue getBulkLValue(ProgramScope scope) {
               final RValue unwinding = getUnwinding(scope);
               return new PointerDereferenceSimple(unwinding);
            }

            @Override
            public RValue getBulkRValue(ProgramScope scope) {
               throw new RuntimeException("TODO: Implement!");
            }
         };
      }

   }

}
