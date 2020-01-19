package dk.camelot64.kickc.passes.unwinding;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.symbols.*;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.*;
import dk.camelot64.kickc.passes.PassNStructPointerRewriting;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.ListIterator;

/** Unwinding for a indexed pointer deref to a struct. */
public class StructUnwindingPointerDerefIndexed implements StructUnwinding {
   private final PointerDereferenceIndexed pointerDeref;
   private final StructDefinition structDefinition;
   private final ControlFlowBlock currentBlock;
   private final ListIterator<Statement> stmtIt;
   private final Statement currentStmt;

   public StructUnwindingPointerDerefIndexed(PointerDereferenceIndexed pointerDeref, StructDefinition structDefinition, ListIterator<Statement> stmtIt, ControlFlowBlock currentBlock, Statement currentStmt) {
      this.structDefinition = structDefinition;
      this.currentBlock = currentBlock;
      this.stmtIt = stmtIt;
      this.pointerDeref = pointerDeref;
      this.currentStmt = currentStmt;
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
      ConstantRef memberOffsetConstant = PassNStructPointerRewriting.getMemberOffsetConstant(programScope, structDefinition, memberName);
      Variable member = structDefinition.getMember(memberName);
      SymbolType memberType = member.getType();
      ArraySpec memberArraySpec = member.getArraySpec();
      return new RValueUnwindingStructPointerDereferenceIndexedMember(pointerDeref, memberType, memberArraySpec, memberOffsetConstant, currentBlock, stmtIt, currentStmt);
   }

}
