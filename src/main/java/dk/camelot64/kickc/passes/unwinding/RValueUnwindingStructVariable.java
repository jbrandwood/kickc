package dk.camelot64.kickc.passes.unwinding;

import dk.camelot64.kickc.model.operators.OperatorSizeOf;
import dk.camelot64.kickc.model.symbols.ArraySpec;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeStruct;
import dk.camelot64.kickc.model.values.*;

/** Value unwinding for a variable. */
public class RValueUnwindingStructVariable implements RValueUnwinding {

   private final Variable variable;

   public RValueUnwindingStructVariable(Variable variable) {
      this.variable = variable;
   }

   @Override
   public SymbolType getSymbolType() {
      return variable.getType();
   }

   @Override
   public ArraySpec getArraySpec() {
      return variable.getArraySpec();
   }

   @Override
   public RValue getUnwinding(ProgramScope programScope) {
      return new ConstantSymbolPointer(variable.getRef());
   }

   @Override
   public boolean isBulkCopyable() {
      return getArraySpec()!=null || variable.isStructClassic() ;
   }

   @Override
   public LValue getBulkLValue(ProgramScope scope) {
      ConstantSymbolPointer pointer = new ConstantSymbolPointer(variable.getRef());
      return new PointerDereferenceSimple(pointer);
   }

   private ConstantValue getByteSize(ProgramScope scope) {
      return getArraySpec()!=null?getArraySpec().getArraySize(): OperatorSizeOf.getSizeOfConstantVar(scope, getSymbolType());
   }

   @Override
   public RValue getBulkRValue(ProgramScope scope) {
      ConstantSymbolPointer pointer = new ConstantSymbolPointer(variable.getRef());
      LValue pointerDeref = new PointerDereferenceSimple(pointer);
      return new MemcpyValue(pointerDeref, getByteSize(scope), getSymbolType());
   }

}
