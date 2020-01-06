package dk.camelot64.kickc.passes.unwinding;

import dk.camelot64.kickc.model.symbols.ArraySpec;
import dk.camelot64.kickc.model.symbols.StructDefinition;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.ConstantStructValue;
import dk.camelot64.kickc.model.values.ConstantValue;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

/** Member unwinding for constant struct value. */
public class StructMemberUnwindingConstantValue implements StructMemberUnwinding {
   private final ConstantStructValue constantStructValue;
   private final StructDefinition structDefinition;

   public StructMemberUnwindingConstantValue(ConstantStructValue constantStructValue, StructDefinition structDefinition) {
      this.constantStructValue = constantStructValue;
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
      final Variable member = structDefinition.getMember(memberName);
      final SymbolType type = member.getType();
      final ArraySpec arraySpec = member.getArraySpec();
      final ConstantValue memberValue = constantStructValue.getValue(member.getRef());
      return new ConstantValueUnwinding(type, arraySpec, memberValue);
   }

}
