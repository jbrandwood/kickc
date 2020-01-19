package dk.camelot64.kickc.passes.unwinding;

import dk.camelot64.kickc.model.symbols.ArraySpec;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.symbols.StructDefinition;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.ConstantStructValue;
import dk.camelot64.kickc.model.values.ConstantValue;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

/** Member unwinding for constant struct value. */
public class StructUnwindingConstant implements StructUnwinding {
   private final ConstantStructValue constantStructValue;
   private final StructDefinition structDefinition;

   public StructUnwindingConstant(ConstantStructValue constantStructValue, StructDefinition structDefinition) {
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
   public RValueUnwinding getMemberUnwinding(String memberName, ProgramScope programScope) {
      final Variable member = structDefinition.getMember(memberName);
      final SymbolType type = member.getType();
      final ArraySpec arraySpec = member.getArraySpec();
      final ConstantValue memberValue = constantStructValue.getValue(member.getRef());
      return new RValueUnwindingConstant(type, arraySpec, memberValue);
   }

}
