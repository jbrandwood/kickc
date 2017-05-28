package dk.camelot64.kickc.icl;

import dk.camelot64.kickc.asm.AsmInstruction;
import dk.camelot64.kickc.asm.AsmLabel;
import dk.camelot64.kickc.asm.AsmLine;
import dk.camelot64.kickc.asm.AsmProgram;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

/** Optimize assembler code by removing jumps to labels immediately following the jump */
public class Pass5NextJumpElimination extends Pass5AsmOptimization {

   public Pass5NextJumpElimination(AsmProgram program) {
      super(program);
   }

   public boolean optimize() {
      List<AsmLine> removeLines = new ArrayList<>();
      AsmInstruction candidate = null;
      for (AsmLine line : getProgram().getLines()) {
         if(candidate!=null) {
            if(line instanceof AsmLabel) {
               if(((AsmLabel) line).getLabel().equals(candidate.getParameter())) {
                  removeLines.add(candidate);
               }
            }
         }
         if(line instanceof AsmInstruction) {
            candidate = null;
            AsmInstruction instruction = (AsmInstruction) line;
            if(instruction.getType().isJump()) {
               candidate = instruction;
            }
         }
      }
      remove(removeLines);
      return removeLines.size()>0;
   }
}
