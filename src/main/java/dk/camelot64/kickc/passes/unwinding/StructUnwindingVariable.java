package dk.camelot64.kickc.passes.unwinding;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.symbols.ArraySpec;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.symbols.StructDefinition;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.*;
import dk.camelot64.kickc.passes.PassNStructPointerRewriting;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.ListIterator;

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
      final SymbolType symbolType = structDefinition.getMember(memberName).getType();
      final ArraySpec arraySpec = structDefinition.getMember(memberName).getArraySpec();
      ConstantRef memberOffsetConstant = PassNStructPointerRewriting.getMemberOffsetConstant(programScope, structDefinition, memberName);
      if(arraySpec==null) {
         // Simple member value - unwind to value of member *((type*)&struct + OFFSET_MEMBER)
         return new RValueUnwindingStructVariableMemberSimple(variable, symbolType, arraySpec, memberOffsetConstant);
      }  else {
         // Array struct member - unwind to pointer to first element (elmtype*)&struct + OFFSET_MEMBER
         return new RValueUnwindingStructVariableMemberArray(variable, symbolType, arraySpec, memberOffsetConstant);
      }
   }

}
