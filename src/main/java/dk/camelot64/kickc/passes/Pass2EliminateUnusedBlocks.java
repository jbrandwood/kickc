package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.symbols.Label;
import dk.camelot64.kickc.model.values.LabelRef;
import dk.camelot64.kickc.model.values.SymbolRef;

import java.util.LinkedHashSet;
import java.util.Set;

/** Pass that eliminates constant if's - they are either removed (if false) or replaces the default successor (if true). */
public class Pass2EliminateUnusedBlocks extends Pass2SsaOptimization {

   public Pass2EliminateUnusedBlocks(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      Set<LabelRef> referencedBlocks = new LinkedHashSet<>();
      findReferencedBlocks(getGraph().getFirstBlock(), referencedBlocks);
      Set<LabelRef> unusedBlocks = new LinkedHashSet<>();
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         if(!referencedBlocks.contains(block.getLabel())) {


            unusedBlocks.add(block.getLabel());
         }
      }
      for(LabelRef unusedBlock : unusedBlocks) {
         getGraph().remove(unusedBlock);
         Label label = getScope().getLabel(unusedBlock);
         label.getScope().remove(label);
         getLog().append("Removing unused block "+unusedBlock);
      }
      return unusedBlocks.size()>0;
   }

   /**
    * Find all referenced block labels recursively
    * @param block The block to add (inc. all blocks that this block calls or jumps to)
    * @param used The blocks already discovered (not examined again)
    */
   private void findReferencedBlocks(ControlFlowBlock block, Set<LabelRef> used) {
      if(block==null) {
         return;
      }
      if(used.contains(block.getLabel())) {
         return;
      }
      used.add(block.getLabel());
      if(block.getCallSuccessor()!=null) {
         findReferencedBlocks(getGraph().getBlock(block.getCallSuccessor()), used);
      }
      if(block.getConditionalSuccessor()!=null) {
         findReferencedBlocks(getGraph().getBlock(block.getConditionalSuccessor()), used);
      }
      if(block.getDefaultSuccessor()!=null) {
         if(block.getDefaultSuccessor().getFullName().equals(SymbolRef.PROCEXIT_BLOCK_NAME)) {
            return;
         }
         findReferencedBlocks(getGraph().getBlock(block.getDefaultSuccessor()), used);
      }
   }


}
