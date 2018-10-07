package dk.camelot64.kickc.model.statements;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.values.BlockScopeRef;

/**
 * Ends a block that introduces a local scope.
 */
public class StatementBlockEnd extends StatementBase {

   /** Reference to the local scope. */
   private BlockScopeRef blockScopeRef;

   public StatementBlockEnd(BlockScopeRef blockScopeRef, StatementSource source) {
      super(null, source);
      this.blockScopeRef = blockScopeRef;
   }

   public BlockScopeRef getBlockScopeRef() {
      return blockScopeRef;
   }

   @Override
   public String toString(Program program, boolean aliveInfo) {
      return super.idxString() + "endblock // " + blockScopeRef.getFullName() + (aliveInfo ? super.aliveString(program) : "");
   }

}
