package dk.camelot64.kickc.passes.unwinding;

import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.symbols.ArraySpec;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.values.*;

class RValueUnwindingStructVariableMemberArray implements RValueUnwinding {
   private Variable structVariable;
   private final SymbolType memberType;
   private final ArraySpec memberArraySpec;
   private final ConstantRef memberOffsetConstant;

   public RValueUnwindingStructVariableMemberArray(Variable structVariable, SymbolType memberType, ArraySpec memberArraySpec, ConstantRef memberOffsetConstant) {
      this.structVariable = structVariable;
      this.memberType = memberType;
      this.memberArraySpec = memberArraySpec;
      this.memberOffsetConstant = memberOffsetConstant;
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
      ConstantSymbolPointer structPointer = new ConstantSymbolPointer(structVariable.getRef());
      // Pointer to member element type (elmtype*)&struct
      SymbolTypePointer memberType = (SymbolTypePointer) getSymbolType();
      ConstantCastValue structTypedPointer = new ConstantCastValue(new SymbolTypePointer(memberType.getElementType()), structPointer);
      // Calculate member address  (elmtype*)&struct + OFFSET_MEMBER
      ConstantBinary memberArrayPointer = new ConstantBinary(structTypedPointer, Operators.PLUS, memberOffsetConstant);
      // Unwind to (elmtype*)&struct + OFFSET_MEMBER
      return memberArrayPointer;
   }

   @Override
   public boolean isBulkCopyable() {
      return true;
   }

   @Override
   public LValue getBulkLValue(ProgramScope scope) {
      RValue memberArrayPointer = getUnwinding(scope);
      return new PointerDereferenceSimple(memberArrayPointer);
   }

   @Override
   public RValue getBulkRValue(ProgramScope scope) {
      RValue memberArrayPointer = getUnwinding(scope);
      return new MemcpyValue(new PointerDereferenceSimple(memberArrayPointer), getArraySpec().getArraySize(), getSymbolType());
   }
}
