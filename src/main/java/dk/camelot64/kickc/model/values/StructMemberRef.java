package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.Program;

/** A reference to a struct member */
public class StructMemberRef implements LValue {

   /** Expression evaluating to a struct. */
   private RValue struct;

   /** Name of the referenced member. */
   private String memberName;

   public StructMemberRef(RValue struct, String memberName) {
      this.struct = struct;
      this.memberName = memberName;
   }

   public RValue getStruct() {
      return struct;
   }

   public void setStruct(RValue struct) {
      this.struct = struct;
   }

   public String getMemberName() {
      return memberName;
   }

   public void setMemberName(String memberName) {
      this.memberName = memberName;
   }

   @Override
   public String toString() {
      return toString(null);
   }

   @Override
   public String toString(Program program) {
      return struct.toString(program) + "." + memberName ;
   }

}
