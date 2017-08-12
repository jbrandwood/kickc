package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.asm.*;
import dk.camelot64.kickc.icl.Program;

import java.util.ArrayList;
import java.util.List;

/**
 * Optimize assembler code by removing jumps to labels immediately following the jump
 */
public class Pass5NextJumpElimination extends Pass5AsmOptimization {

   public Pass5NextJumpElimination(Program program) {
      super(program);
   }

   public boolean optimize() {
      List<AsmLine> removeLines = new ArrayList<>();
      AsmInstruction candidate = null;
      for (AsmSegment segment : getAsmProgram().getSegments()) {
         for (AsmLine line : segment.getLines()) {
            if (candidate != null) {
               if (line instanceof AsmLabel) {
                  if (((AsmLabel) line).getLabel().equals(candidate.getParameter())) {
                     removeLines.add(candidate);
                  }
               }
            }
            if (line instanceof AsmInstruction) {
               candidate = null;
               AsmInstruction instruction = (AsmInstruction) line;
               if (instruction.getType().isJump() && !instruction.getType().getMnemnonic().equals("jsr")) {
                  candidate = instruction;
               }
            }
         }

      }
      remove(removeLines);
      return removeLines.size() > 0;
   }
}
