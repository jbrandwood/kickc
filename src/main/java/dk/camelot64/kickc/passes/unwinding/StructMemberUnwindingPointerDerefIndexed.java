package dk.camelot64.kickc.passes.unwinding;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.symbols.*;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.values.*;
import dk.camelot64.kickc.passes.PassNStructPointerRewriting;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.ListIterator;

/** Unwinding for a indexed pointer deref to a struct. */
public class StructMemberUnwindingPointerDerefIndexed implements StructMemberUnwinding {
   private final PointerDereferenceIndexed pointerDeref;
   private final StructDefinition structDefinition;
   private final ControlFlowBlock currentBlock;
   private final ListIterator<Statement> stmtIt;
   private final Statement currentStmt;

   public StructMemberUnwindingPointerDerefIndexed(PointerDereferenceIndexed pointerDeref, StructDefinition structDefinition, ListIterator<Statement> stmtIt, ControlFlowBlock currentBlock, Statement currentStmt) {
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
   public RValueUnwinding getMemberUnwinding(String memberName) {
      return new RValueUnwinding() {
         @Override
         public SymbolType getSymbolType() {
            return structDefinition.getMember(memberName).getType();
         }

         @Override
         public ArraySpec getArraySpec() {
            return structDefinition.getMember(memberName).getArraySpec();
         }

         @Override
         public RValue getUnwinding(ProgramScope programScope) {
            ConstantRef memberOffsetConstant = PassNStructPointerRewriting.getMemberOffsetConstant(programScope, structDefinition, memberName);
            Variable member = structDefinition.getMember(memberName);
            Scope scope = programScope.getScope(currentBlock.getScope());
            Variable memberAddress = scope.addVariableIntermediate();
            memberAddress.setType(new SymbolTypePointer(member.getType()));
            CastValue structTypedPointer = new CastValue(new SymbolTypePointer(member.getType()), pointerDeref.getPointer());
            // Add statement $1 = ptr_struct + OFFSET_STRUCT_NAME_MEMBER
            stmtIt.add(new StatementAssignment((LValue) memberAddress.getRef(), structTypedPointer, Operators.PLUS, memberOffsetConstant, true, currentStmt.getSource(), currentStmt.getComments()));
            // Unwind to *(ptr_struct+OFFSET_STRUCT_NAME_MEMBER[idx]
            return new PointerDereferenceIndexed(memberAddress.getRef(), pointerDeref.getIndex());
         }

         @Override
         public boolean isBulkCopyable() {
            return getArraySpec()!=null;
         }

         @Override
         public LValue getBulkLValue(ProgramScope scope) {
            return (LValue) getUnwinding(scope);
         }

         @Override
         public RValue getBulkRValue(ProgramScope scope) {
            throw new RuntimeException("TODO: Implement!");
         }
      };
   }

}
