package dk.camelot64.kickc.model.symbols;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeBlockScope;

/**
 * A block inside a function creating a local scope.
 */
public class BlockScope extends Scope {

   public BlockScope(String name, Scope parentScope) {
      super(name, parentScope, parentScope.getSegmentData());
   }

   @Override
   public SymbolType getType() {
      return new SymbolTypeBlockScope();
   }

   @Override
   public String toString(Program program) {
      return "block-"+getFullName();
   }
}
