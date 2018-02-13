package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.asm.AsmComment;
import dk.camelot64.kickc.asm.AsmLine;
import dk.camelot64.kickc.asm.AsmSegment;
import dk.camelot64.kickc.model.Program;

/**
 * Reindex ASM lines
 */
public class Pass5ReindexAsmLines extends Pass5AsmOptimization {

   public Pass5ReindexAsmLines(Program program) {
      super(program);
   }

   public boolean optimize() {
      int nextIndex =0;
      for(AsmSegment asmSegment : getAsmProgram().getSegments()) {
         for(AsmLine asmLine : asmSegment.getLines()) {
            if((asmLine instanceof AsmComment)) {
               asmLine.setIndex(-1);
            } else {
               asmLine.setIndex(nextIndex++);
            }
         }
      }
      getAsmProgram().setNextLineIndex(nextIndex);
      return false;
   }
}
