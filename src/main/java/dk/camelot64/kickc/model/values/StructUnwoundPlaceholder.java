package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.types.SymbolTypeStruct;

import java.util.List;

/** Used as a placeholder value, where a struct has been unwound. */
public class StructUnwoundPlaceholder implements RValue {

   public StructUnwoundPlaceholder(SymbolTypeStruct typeStruct, List<RValue> unwoundMembers) {
      this.typeStruct = typeStruct;
      this.unwoundMembers = unwoundMembers;
   }

   /** The type of the struct. */
   private SymbolTypeStruct typeStruct;

   /** The unwound struct members. */
   private List<RValue> unwoundMembers;

   public SymbolTypeStruct getTypeStruct() {
      return typeStruct;
   }

   public List<RValue> getUnwoundMembers() {
      return unwoundMembers;
   }

   @Override
   public String toString(Program program) {
      StringBuffer str = new StringBuffer();
      str.append("struct-unwound {");
      boolean first = true;
      for(RValue unwoundMember : unwoundMembers) {
         if(first) {
            first = false;
         } else {
            str.append(", ");
         }
         str.append(unwoundMember.toString(program));
      }
      str.append("}");
      return str.toString();
   }

}
