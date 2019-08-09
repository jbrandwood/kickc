package dk.camelot64.kickc.model.symbols;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeTypeDefScope;

public class TypeDefsScope extends Scope {

   public TypeDefsScope(String name, Scope parentScope) {
      super(name, parentScope, parentScope.getSegmentData());
   }

   @Override
   public SymbolType getType() {
      return new SymbolTypeTypeDefScope();
   }

   @Override
   public String toString(Program program) {
      return "typedefs";
   }
}
