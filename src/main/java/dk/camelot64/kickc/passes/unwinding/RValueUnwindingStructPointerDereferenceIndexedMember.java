package dk.camelot64.kickc.passes.unwinding;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.symbols.*;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.values.*;

import java.util.ListIterator;

class RValueUnwindingStructPointerDereferenceIndexedMember implements RValueUnwinding {
   private final PointerDereferenceIndexed structPointerDeref;
   private final SymbolType memberType;
   private final ArraySpec memberArraySpec;
   private final ConstantRef memberOffsetConstant;
   private final ControlFlowBlock currentBlock;
   private final ListIterator<Statement> stmtIt;
   private final Statement currentStmt;

   public RValueUnwindingStructPointerDereferenceIndexedMember(PointerDereferenceIndexed structPointerDeref, SymbolType memberType, ArraySpec memberArraySpec, ConstantRef memberOffsetConstant, ControlFlowBlock currentBlock, ListIterator<Statement> stmtIt, Statement currentStmt) {
      this.structPointerDeref = structPointerDeref;
      this.memberType = memberType;
      this.memberArraySpec = memberArraySpec;
      this.memberOffsetConstant = memberOffsetConstant;
      this.currentBlock = currentBlock;
      this.stmtIt = stmtIt;
      this.currentStmt = currentStmt;
   }

   @Override
   public SymbolType getSymbolType() {
      return memberType;
   }

   @Override
   public ArraySpec getArraySpec() {
      return memberArraySpec;
   }

   @Override
   public RValue getUnwinding(ProgramScope programScope) {
      Scope scope = programScope.getScope(currentBlock.getScope());
      Variable memberAddress = scope.addVariableIntermediate();
      memberAddress.setType(new SymbolTypePointer(memberType));
      CastValue structTypedPointer = new CastValue(new SymbolTypePointer(memberType), structPointerDeref.getPointer());
      // Add statement $1 = ptr_struct + OFFSET_STRUCT_NAME_MEMBER
      stmtIt.add(new StatementAssignment((LValue) memberAddress.getRef(), structTypedPointer, Operators.PLUS, memberOffsetConstant, true, currentStmt.getSource(), currentStmt.getComments()));
      // Unwind to *(ptr_struct+OFFSET_STRUCT_NAME_MEMBER[idx]
      return new PointerDereferenceIndexed(memberAddress.getRef(), structPointerDeref.getIndex());
   }

   @Override
   public boolean isBulkCopyable() {
      return getArraySpec() != null;
   }

   @Override
   public LValue getBulkLValue(ProgramScope scope) {
      return (LValue) getUnwinding(scope);
   }

   @Override
   public RValue getBulkRValue(ProgramScope scope) {
      throw new RuntimeException("TODO: Implement!");
   }
}
