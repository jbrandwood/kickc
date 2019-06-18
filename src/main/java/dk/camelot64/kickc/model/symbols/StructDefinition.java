package dk.camelot64.kickc.model.symbols;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeStruct;

/**
 * A struct definition containing a set of variables.
 */
public class StructDefinition extends Scope {

   public StructDefinition(String name, Scope parentScope) {
      super(name, parentScope);
   }

   @Override
   public SymbolType getType() {
      return new SymbolTypeStruct(this);
   }

   /**
    * Get a struct member variable
    * @param name The name of the member
    * @return The member variable
    */
   public Variable getMember(String name) {
      for(Variable member : getAllVariables(false)) {
         if(member.getLocalName().equals(name)) {
            return member;
         }
      }
      return null;
   }

   /**
    * Get the number of bytes that the member data is offset from the start of the struct
    * @param member The member to find offset for
    * @return The byte offset of the start of the member data
    */
   public long getMemberByteOffset(Variable member) {
      long byteOffset=0;
      for(Variable structMember : getAllVariables(false)) {
         if(structMember.equals(member)) {
            break;
         } else {
            byteOffset += structMember.getType().getSizeBytes();
         }
      }
      return byteOffset;
   }

   @Override
   public String toString(Program program) {
      return "struct-"+getFullName();
   }
}
