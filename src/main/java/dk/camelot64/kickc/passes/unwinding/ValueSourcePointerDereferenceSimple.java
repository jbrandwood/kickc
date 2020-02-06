package dk.camelot64.kickc.passes.unwinding;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.symbols.*;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.types.SymbolTypeStruct;
import dk.camelot64.kickc.model.values.*;
import dk.camelot64.kickc.passes.PassNStructPointerRewriting;

import java.util.ListIterator;

/** Value Source for a pointer dereference. */
public class ValueSourcePointerDereferenceSimple extends ValueSourceBase {

   /** The pointer dereference. */
   private final PointerDereferenceSimple pointerDereference;
   /** The type of the value. */
   private SymbolType valueType;
   /** The array spec of the value. */
   private final ArraySpec valueArraySpec;

   public ValueSourcePointerDereferenceSimple(PointerDereferenceSimple pointerDereference, SymbolType valueType, ArraySpec valueArraySpec) {
      this.pointerDereference = pointerDereference;
      this.valueType = valueType;
      this.valueArraySpec = valueArraySpec;
   }

   @Override
   public SymbolType getSymbolType() {
      return valueType;
   }

   @Override
   public ArraySpec getArraySpec() {
      return valueArraySpec;
   }

   @Override
   protected boolean isStructClassic() {
      return getSymbolType() instanceof SymbolTypeStruct;
   }

   @Override
   public RValue getSimpleValue(ProgramScope programScope) {
      return pointerDereference;
   }

   @Override
   public LValue getBulkLValue(ProgramScope scope) {
      return pointerDereference;
   }

   @Override
   public RValue getBulkRValue(ProgramScope scope) {
      return new MemcpyValue(pointerDereference, getByteSize(scope), getSymbolType());
   }

   @Override
   public ValueSource getMemberUnwinding(String memberName, Program program, ProgramScope programScope, Statement currentStmt, ListIterator<Statement> stmtIt, ControlFlowBlock currentBlock) {
      StructDefinition structDefinition = ((SymbolTypeStruct) getSymbolType()).getStructDefinition(programScope);
      final SymbolType memberType = structDefinition.getMember(memberName).getType();
      final ArraySpec memberArraySpec = structDefinition.getMember(memberName).getArraySpec();
      ConstantRef memberOffsetConstant = PassNStructPointerRewriting.getMemberOffsetConstant(programScope, structDefinition, memberName);
      // Simple member value - unwind to value of member *((type*)&struct + OFFSET_MEMBER)
      final RValue structPointer = pointerDereference.getPointer();
      if(structPointer instanceof ConstantValue) {
         if(memberArraySpec!=null) {
            SymbolType elementType = ((SymbolTypePointer) memberType).getElementType();
            SymbolTypePointer pointerToElementType = new SymbolTypePointer(elementType);
            // Pointer to member element type
            ConstantCastValue structTypedPointer = new ConstantCastValue(pointerToElementType, (ConstantValue) structPointer);
            // Calculate member address  (elmtype*)&struct + OFFSET_MEMBER
            ConstantBinary memberPointer = new ConstantBinary(structTypedPointer, Operators.PLUS, memberOffsetConstant);
            // Unwind to *((type*)&struct + OFFSET_MEMBER)
            return new ValueSourceConstant(pointerToElementType, null, memberPointer);
         }  else {
            // Pointer to member type
            ConstantCastValue structTypedPointer = new ConstantCastValue(new SymbolTypePointer(memberType), (ConstantValue) structPointer);
            // Calculate member address  (memberType*)&struct + OFFSET_MEMBER
            ConstantBinary memberPointer = new ConstantBinary(structTypedPointer, Operators.PLUS, memberOffsetConstant);
            // Unwind to *((memberType*)&struct + OFFSET_MEMBER)
            PointerDereferenceSimple memberDeref = new PointerDereferenceSimple(memberPointer);
            return new ValueSourcePointerDereferenceSimple(memberDeref, memberType, null);
         }
      } else {
         if(memberArraySpec!=null) {
            SymbolType elementType = ((SymbolTypePointer) memberType).getElementType();
            SymbolTypePointer pointerToElementType = new SymbolTypePointer(elementType);
            Scope scope = programScope.getScope(currentBlock.getScope());
            Variable memberAddress = scope.addVariableIntermediate();
            memberAddress.setType(pointerToElementType);
            CastValue elementTypedPointer = new CastValue(pointerToElementType, structPointer);
            // Add statement $1 = (elmType*)ptr_struct + OFFSET_MEMBER
            stmtIt.previous();
            stmtIt.add(new StatementAssignment((LValue) memberAddress.getRef(), elementTypedPointer, Operators.PLUS, memberOffsetConstant, true, currentStmt.getSource(), currentStmt.getComments()));
            stmtIt.next();
            // Unwind to *((elmType*)ptr_struct+OFFSET_MEMBER)
            return new ValueSourceVariable(memberAddress);
         }  else {
            Scope scope = programScope.getScope(currentBlock.getScope());
            Variable memberAddress = scope.addVariableIntermediate();
            memberAddress.setType(new SymbolTypePointer(memberType));
            CastValue structTypedPointer = new CastValue(new SymbolTypePointer(memberType), structPointer);
            // Add statement $1 = (memberType*)ptr_struct + OFFSET_MEMBER
            stmtIt.previous();
            stmtIt.add(new StatementAssignment((LValue) memberAddress.getRef(), structTypedPointer, Operators.PLUS, memberOffsetConstant, true, currentStmt.getSource(), currentStmt.getComments()));
            stmtIt.next();
            // Unwind to *((memberType*)ptr_struct+OFFSET_MEMBER)
            PointerDereferenceSimple memberDeref = new PointerDereferenceSimple(memberAddress.getRef());
            return new ValueSourcePointerDereferenceSimple(memberDeref, memberType, null);
         }
      }
   }
}

