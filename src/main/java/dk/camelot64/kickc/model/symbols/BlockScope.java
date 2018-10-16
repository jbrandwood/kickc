package dk.camelot64.kickc.model.symbols;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeBlockScope;
import dk.camelot64.kickc.model.values.BlockScopeRef;

/**
 * A code block introducing a local scope.
 *
 * Introduced by a local code block { } or a for()-loop.
 */
public class BlockScope extends Scope {

   public BlockScope(String name, Scope parentScope) {
      super(name, parentScope);
   }

   @Override
   public SymbolType getType() {
      return new SymbolTypeBlockScope();
   }

   public BlockScopeRef getRef() {
      return new BlockScopeRef(this.getFullName());
   }

   @Override
   public String toString(Program program) {
      return "scope "+getFullName();
   }

   @Override
   public VariableIntermediate addVariableIntermediate() {
      return getScope().addVariableIntermediate();
   }

   @Override
   public Label addLabelIntermediate() {
      return getScope().addLabelIntermediate();
   }

   @Override
   public String allocateIntermediateLabelName() {
      return getScope().allocateIntermediateLabelName();
   }

   @Override
   public String allocateIntermediateVariableName() {
      return getScope().allocateIntermediateVariableName();
   }
}
