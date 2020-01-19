package dk.camelot64.kickc.passes.unwinding;

import dk.camelot64.kickc.model.operators.OperatorSizeOf;
import dk.camelot64.kickc.model.symbols.ArraySpec;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeStruct;
import dk.camelot64.kickc.model.values.*;

/** Value unwinding for a simple pointer to a struct. */
public class RValueUnwindingStructPointerDeref implements RValueUnwinding {

   /** Pointer to struct value. */
   private final PointerDereference structPointerDereference;
   /** Struct type. */
   private final SymbolTypeStruct structType;

   public RValueUnwindingStructPointerDeref(PointerDereference structPointerDereference, SymbolTypeStruct structType) {
      this.structPointerDereference = structPointerDereference;
      this.structType = structType;
   }

   @Override
   public SymbolType getSymbolType() {
      return structType;
   }

   @Override
   public ArraySpec getArraySpec() {
      return null;
   }

   @Override
   public RValue getUnwinding(ProgramScope programScope) {
      return structPointerDereference.getPointer();
   }

   @Override
   public boolean isBulkCopyable() {
      return true;
   }

   @Override
   public LValue getBulkLValue(ProgramScope scope) {
      return structPointerDereference;
   }

   private ConstantValue getByteSize(ProgramScope scope) {
      return OperatorSizeOf.getSizeOfConstantVar(scope, getSymbolType());
   }

   @Override
   public RValue getBulkRValue(ProgramScope scope) {
      return new MemcpyValue(structPointerDereference, getByteSize(scope), getSymbolType());
   }

}
