package dk.camelot64.kickc.passes.unwinding;

import dk.camelot64.kickc.model.Initializers;
import dk.camelot64.kickc.model.InternalError;
import dk.camelot64.kickc.model.operators.OperatorSizeOf;
import dk.camelot64.kickc.model.symbols.ArraySpec;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeStruct;
import dk.camelot64.kickc.model.values.*;

/** Assignment unwinding for a zero value. */
public class RValueUnwindingZero implements RValueUnwinding {
   private final SymbolType symbolType;
   private final ArraySpec arraySpec;

   public RValueUnwindingZero(SymbolType symbolType, ArraySpec arraySpec) {
      this.symbolType = symbolType;
      this.arraySpec = arraySpec;
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
      return Initializers.createZeroValue(new Initializers.ValueTypeSpec(getSymbolType(), getArraySpec()), null);
   }

   @Override
   public boolean isBulkCopyable() {
      return arraySpec!=null || symbolType instanceof SymbolTypeStruct;
   }

   @Override
   public LValue getBulkLValue(ProgramScope scope) {
      throw new InternalError("Not a legal LValue!");
   }

   @Override
   public RValue getBulkRValue(ProgramScope scope) {
      ConstantValue byteSize;
      if(getArraySpec()!=null) {
         byteSize = getArraySpec().getArraySize();
      } else if(symbolType instanceof SymbolTypeStruct) {
         byteSize = OperatorSizeOf.getSizeOfConstantVar(scope, symbolType);
      } else {
         throw new InternalError("Bulk unwinding of zero value not handled "+symbolType.getTypeName());
      }
      return new MemsetValue(byteSize, getSymbolType());
   }

}
