package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.PhiTransitions;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.values.LabelRef;

import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Generate phi-transitions for all phi-block transitions
 */
public class PassNCalcPhiTransitions extends PassNCalcBase<Map<LabelRef, PhiTransitions>> {

   public PassNCalcPhiTransitions(Program program) {
      super(program);
   }

   @Override
   public Map<LabelRef, PhiTransitions> calculate() {
      LinkedHashMap<LabelRef, PhiTransitions> phiTransitions = new LinkedHashMap<>();
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         PhiTransitions blockTransitions = new PhiTransitions(getProgram(), block);
         phiTransitions.put(block.getLabel(), blockTransitions);
      }
      return phiTransitions;
   }


}
