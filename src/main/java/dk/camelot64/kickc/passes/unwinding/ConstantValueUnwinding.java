package dk.camelot64.kickc.passes.unwinding;

import dk.camelot64.kickc.model.symbols.ArraySpec;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.symbols.Scope;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.*;

/** Unwinding a constant value. */
public class ConstantValueUnwinding implements RValueUnwinding {
   private final SymbolType symbolType;
   private final ArraySpec arraySpec;
   private final ConstantValue value;

   public ConstantValueUnwinding(SymbolType symbolType, ArraySpec arraySpec, ConstantValue value) {
      this.symbolType = symbolType;
      this.arraySpec = arraySpec;
      this.value = value;
   }

   @Override
   public SymbolType getSymbolType() {
      return symbolType;
   }

   @Override
   public ArraySpec getArraySpec() {
      return arraySpec;
   }

   @Override
   public RValue getUnwinding(ProgramScope programScope) {
      return value;
   }

   @Override
   public boolean isBulkCopyable() {
      return getArraySpec()!=null;
   }

   @Override
   public LValue getBulkLValue(ProgramScope scope) {
      throw new InternalError("Not a valid LValue!");
   }

   @Override
   public RValue getBulkRValue(ProgramScope scope) {
      String constName = scope.allocateIntermediateVariableName();
      Variable constVar = Variable.createConstant(constName, symbolType, scope, getArraySpec(), value, Scope.SEGMENT_DATA_DEFAULT);
      scope.add(constVar);
      return new MemcpyValue(new PointerDereferenceSimple(constVar.getRef()), getArraySpec().getArraySize());
   }

}
