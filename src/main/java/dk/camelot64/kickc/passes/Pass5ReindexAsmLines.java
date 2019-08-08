package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.asm.*;
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
      for(AsmChunk asmChunk : getAsmProgram().getChunks()) {
         for(AsmLine asmLine : asmChunk.getLines()) {
            if((asmLine instanceof AsmComment)) {
               asmLine.setIndex(nextIndex);
               nextIndex += ((AsmComment) asmLine).getLineCount();
            } else if(asmLine instanceof AsmInlineKickAsm) {
               asmLine.setIndex(nextIndex);
               AsmInlineKickAsm inlineKickAsm = (AsmInlineKickAsm) asmLine;
               nextIndex += inlineKickAsm.getLineCount();
            } else if(asmLine instanceof AsmDataKickAsm) {
               asmLine.setIndex(nextIndex);
               AsmDataKickAsm inlineKickAsm = (AsmDataKickAsm) asmLine;
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
