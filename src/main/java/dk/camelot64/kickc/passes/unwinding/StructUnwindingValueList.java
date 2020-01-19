package dk.camelot64.kickc.passes.unwinding;

import dk.camelot64.kickc.model.symbols.ArraySpec;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.symbols.StructDefinition;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.RValue;
import dk.camelot64.kickc.model.values.ValueList;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

/** Member unwinding for a struct valueList. */
public class StructUnwindingValueList implements StructUnwinding {

   private final StructDefinition structDefinition;
   private final ValueList valueList;

   public StructUnwindingValueList(ValueList valueList, StructDefinition structDefinition) {
      this.valueList = valueList;
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
      final SymbolType type = structDefinition.getMember(memberName).getType();
      final ArraySpec arraySpec = structDefinition.getMember(memberName).getArraySpec();
      int memberIndex = getMemberNames().indexOf(memberName);
      final RValue memberValue = valueList.getList().get(memberIndex);
      return new RValueUnwindingSimple(type, arraySpec, memberValue);
   }

}
