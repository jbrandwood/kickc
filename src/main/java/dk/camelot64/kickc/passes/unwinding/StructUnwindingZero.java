package dk.camelot64.kickc.passes.unwinding;

import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.symbols.StructDefinition;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.values.StructZero;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

/** Unwinding for StructZero */
public class StructUnwindingZero implements StructUnwinding {
   private StructZero structZero;
   private StructDefinition structDefinition;

   public StructUnwindingZero(StructZero structZero, StructDefinition structDefinition) {
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
   public RValueUnwinding getMemberUnwinding(String memberName, ProgramScope programScope) {
      Variable member = structDefinition.getMember(memberName);
      return new RValueUnwindingZero(member.getType(), member.getArraySpec());
   }

}
