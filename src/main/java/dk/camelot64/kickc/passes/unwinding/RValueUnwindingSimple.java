package dk.camelot64.kickc.passes.unwinding;

import dk.camelot64.kickc.model.symbols.ArraySpec;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.LValue;
import dk.camelot64.kickc.model.values.RValue;

/** Value unwinding that just returns a non-unwindable RValue. */
class RValueUnwindingSimple implements RValueUnwinding {
   private final SymbolType type;
   private final ArraySpec arraySpec;
   private final RValue memberValue;

   public RValueUnwindingSimple(SymbolType type, ArraySpec arraySpec, RValue memberValue) {
      this.type = type;
      this.arraySpec = arraySpec;
      this.memberValue = memberValue;
   }

   @Override
   public SymbolType getSymbolType() {
      return type;
   }

   @Override
   public ArraySpec getArraySpec() {
      return arraySpec;
   }

   @Override
   public RValue getUnwinding(ProgramScope programScope) {
      return memberValue;
   }

   @Override
   public boolean isBulkCopyable() {
      return false;
   }

   @Override
   public LValue getBulkLValue(ProgramScope scope) {
      throw new RuntimeException("TODO: Implement!");
   }

   @Override
   public RValue getBulkRValue(ProgramScope scope) {
      throw new RuntimeException("TODO: Implement!");
   }

}
