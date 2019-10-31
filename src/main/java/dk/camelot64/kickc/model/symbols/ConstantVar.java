package dk.camelot64.kickc.model.symbols;

import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.ConstantRef;
import dk.camelot64.kickc.model.values.ConstantValue;

/** A named constant or a variable that has been inferred to be constant in the symbol table */
public class ConstantVar extends SymbolVariable {

   public ConstantVar(String name, Scope scope, SymbolType type, ConstantValue value, String dataSegment) {
      super(name, scope, type, StorageStrategy.CONSTANT, MemoryArea.MAIN_MEMORY, dataSegment);
      setConstantValue(value);
   }

   @Override
   public ConstantRef getRef() {
      return new ConstantRef(this);
   }

}
