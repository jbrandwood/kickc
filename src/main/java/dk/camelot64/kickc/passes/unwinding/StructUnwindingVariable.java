package dk.camelot64.kickc.passes.unwinding;

import dk.camelot64.kickc.model.symbols.ArraySpec;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.symbols.StructDefinition;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.ConstantRef;
import dk.camelot64.kickc.passes.PassNStructPointerRewriting;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

/** Unwinding for a struct value with C-classic memory layout. */
public class StructUnwindingVariable implements StructUnwinding {
   private Variable variable;
   private StructDefinition structDefinition;

   public StructUnwindingVariable(Variable variable, StructDefinition structDefinition) {
      this.variable = variable;
      this.structDefinition = structDefinition;
   }

   @Override
   public List<String> getMemberNames() {
      Collection<Variable> structMemberVars = structDefinition.getAllVars(false);
      ArrayList<String> memberNames = new ArrayList<>();
      for(Variable structMemberVar : structMemberVars) {
         memberNames.add(structMemberVar.getLocalName());
      }
      return memberNames;
   }

   @Override
   public RValueUnwinding getMemberUnwinding(String memberName, ProgramScope programScope) {
      final SymbolType memberType = structDefinition.getMember(memberName).getType();
      final ArraySpec memberArraySpec = structDefinition.getMember(memberName).getArraySpec();
      ConstantRef memberOffsetConstant = PassNStructPointerRewriting.getMemberOffsetConstant(programScope, structDefinition, memberName);
      if(memberArraySpec==null) {
         // Simple member value - unwind to value of member *((type*)&struct + OFFSET_MEMBER)
         return new RValueUnwindingStructVariableMemberSimple(variable, memberType, memberArraySpec, memberOffsetConstant);
      }  else {
         // Array struct member - unwind to pointer to first element (elmtype*)&struct + OFFSET_MEMBER
         return new RValueUnwindingStructVariableMemberArray(variable, memberType, memberArraySpec, memberOffsetConstant);
      }
   }

}
