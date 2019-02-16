package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.asm.AsmComment;
import dk.camelot64.kickc.asm.AsmInlineKickAsm;
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
               asmLine.setIndex(nextIndex);
               nextIndex += ((AsmComment) asmLine).getLineCount();
            } else if(asmLine instanceof AsmInlineKickAsm) {
               asmLine.setIndex(nextIndex);
               AsmInlineKickAsm inlineKickAsm = (AsmInlineKickAsm) asmLine;
               nextIndex += inlineKickAsm.getLineCount();
            } else {
               asmLine.setIndex(nextIndex++);
            }
         }
      }
      getAsmProgram().setNextLineIndex(nextIndex);
      return false;
   }
}
