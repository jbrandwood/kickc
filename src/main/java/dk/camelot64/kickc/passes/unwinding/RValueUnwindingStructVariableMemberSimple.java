package dk.camelot64.kickc.passes.unwinding;

import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.symbols.ArraySpec;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.values.*;

class RValueUnwindingStructVariableMemberSimple implements RValueUnwinding {
   private Variable structVariable;
   private final SymbolType memberType;
   private final ArraySpec memberArraySpec;
   private final ConstantRef memberOffsetConstant;

   public RValueUnwindingStructVariableMemberSimple(Variable structVariable, SymbolType memberType, ArraySpec memberArraySpec, ConstantRef memberOffsetConstant) {
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
      // Pointer to member type
      ConstantCastValue structTypedPointer = new ConstantCastValue(new SymbolTypePointer(getSymbolType()), structPointer);
      // Calculate member address  (type*)&struct + OFFSET_MEMBER
      ConstantBinary memberArrayPointer = new ConstantBinary(structTypedPointer, Operators.PLUS, memberOffsetConstant);
      // Unwind to *((type*)&struct + OFFSET_MEMBER)
      return new PointerDereferenceSimple(memberArrayPointer);
   }

   @Override
   public boolean isBulkCopyable() {
      return false;
   }

   @Override
   public LValue getBulkLValue(ProgramScope scope) {
      return null;
   }

   @Override
   public RValue getBulkRValue(ProgramScope scope) {
      return null;
   }

}
