package dk.camelot64.kickc.model.symbols;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeStruct;

/**
 * A struct definition containing a set of variables.
 * The struct definition can either represent a struct (member memory-layout is linearly consecutive ) or a union (member start at the same memory address)
 */
public class StructDefinition extends Scope {

   private boolean isUnion;

   public StructDefinition(String name, boolean isUnion, Scope parentScope) {
      super(name, parentScope, SEGMENT_DATA_DEFAULT);
      this.isUnion = isUnion;
   }

   @Override
   public SymbolType getType() {
      return new SymbolTypeStruct(this, false, false);
   }

   public boolean isUnion() {
      return isUnion;
   }

   /**
    * Get a struct member variable
    *
    * @param name The name of the member
    * @return The member variable
    */
   public Variable getMember(String name) {
      for(Variable member : getAllVars(false)) {
         if(member.getLocalName().equals(name)) {
            return member;
         }
      }
      return null;
   }

   /**
    * Get the number of bytes that the member data is offset from the start of the struct
    *
    * @param member The member to find offset for
    * @return The byte offset of the start of the member data
    */
   public long getMemberByteOffset(Variable member, ProgramScope programScope) {
      if(isUnion)
         return 0;
      long byteOffset = 0;
      for(Variable structMember : getAllVars(false)) {
         if(structMember.equals(member)) {
            break;
         } else {
            byteOffset += SymbolTypeStruct.getMemberSizeBytes(structMember.getType(), structMember.getArraySize(), programScope);
         }
      }
      return byteOffset;
   }

   @Override
   public String toString(Program program) {
      if(isUnion) {
         return "union-" + getFullName();
      } else {
         return "struct-" + getFullName();
      }
   }
}
