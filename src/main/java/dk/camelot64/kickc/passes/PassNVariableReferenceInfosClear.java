package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.Program;

/**
 * Clear the cached variable reference infos.
 */
public class PassNVariableReferenceInfosClear extends Pass2SsaOptimization {

   public PassNVariableReferenceInfosClear(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      getProgram().clearVariableReferenceInfos();
      return false;
   }
}
