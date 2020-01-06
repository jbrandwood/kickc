package dk.camelot64.kickc.passes.unwinding;

import dk.camelot64.kickc.model.symbols.StructDefinition;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.values.StructZero;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

/** Unwinding for StructZero */
public class StructMemberUnwindingZero implements StructMemberUnwinding {
   private StructZero structZero;
   private StructDefinition structDefinition;

   public StructMemberUnwindingZero(StructZero structZero, StructDefinition structDefinition) {
      this.structZero = structZero;
      this.structDefinition = structDefinition;
   }

   @Override
   public List<String> getMemberNames() {
      Collection<Variable> structMemberVars = structDefinition.getAllVariables(false);
      ArrayList<String> memberNames = new ArrayList<>();
      for(Variable structMemberVar : structMemberVars) {
         memberNames.add(structMemberVar.getLocalName());
      }
      return memberNames;
   }

   @Override
   public RValueUnwinding getMemberUnwinding(String memberName) {
      Variable member = structDefinition.getMember(memberName);
      return new ZeroValueUnwinding(member.getType(), member.getArraySpec());
   }

}
