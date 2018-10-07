package dk.camelot64.kickc.model.statements;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.values.BlockScopeRef;
import dk.camelot64.kickc.model.values.LabelRef;

/**
 * Begins a block that introduces a local scope.
 */
public class StatementBlockBegin extends StatementBase {

   /** The reference to the scope. */
   private BlockScopeRef blockScopeRef;
   /** The label of the first code of the scope. */
   private LabelRef blockLabelRef;

   public StatementBlockBegin(BlockScopeRef blockScopeRef, LabelRef blockLabelRef, StatementSource source) {
      super(null, source);
      this.blockScopeRef = blockScopeRef;
      this.blockLabelRef= blockLabelRef;
   }

   public BlockScopeRef getBlockScopeRef() {
      return blockScopeRef;
   }

   public LabelRef getBlockLabelRef() {
      return blockLabelRef;
   }

   @Override
   public String toString(Program program, boolean aliveInfo) {
      return super.idxString() + "block " + blockScopeRef.getFullName() + (aliveInfo ? super.aliveString(program) : "");
   }

}
