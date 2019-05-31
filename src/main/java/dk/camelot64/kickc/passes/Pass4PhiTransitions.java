package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.PhiTransitions;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.values.LabelRef;

import java.util.LinkedHashMap;

/**
 * Generate phi-transitions for all phi-block transitions
 */
public class Pass4PhiTransitions extends Pass2Base {

   public Pass4PhiTransitions(Program program) {
      super(program);
   }

   public void generate() {
      LinkedHashMap<LabelRef, PhiTransitions> phiTransitions = new LinkedHashMap<>();
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         PhiTransitions blockTransitions = new PhiTransitions(getProgram(), block);
         phiTransitions.put(block.getLabel(), blockTransitions);
      }
      getProgram().setPhiTransitions(phiTransitions);
   }


}
