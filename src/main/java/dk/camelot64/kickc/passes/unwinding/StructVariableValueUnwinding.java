package dk.camelot64.kickc.passes.unwinding;

import dk.camelot64.kickc.model.symbols.ArraySpec;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.*;

/** Value unwinding for a variable. */
public class StructVariableValueUnwinding implements RValueUnwinding {

   private final Variable variable;

   public StructVariableValueUnwinding(Variable variable) {
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
      ConstantSymbolPointer pointer = new ConstantSymbolPointer(variable.getRef());
      return pointer;
   }

   @Override
   public boolean isBulkCopyable() {
      return getArraySpec()!=null;
   }

   @Override
   public LValue getBulkLValue(ProgramScope scope) {
      ConstantSymbolPointer pointer = new ConstantSymbolPointer(variable.getRef());
      LValue pointerDeref = new PointerDereferenceSimple(pointer);
      return pointerDeref;
   }

   @Override
   public RValue getBulkRValue(ProgramScope scope) {
      ConstantSymbolPointer pointer = new ConstantSymbolPointer(variable.getRef());
      LValue pointerDeref = new PointerDereferenceSimple(pointer);
      return new MemcpyValue(pointerDeref, getArraySpec().getArraySize());
   }

}
