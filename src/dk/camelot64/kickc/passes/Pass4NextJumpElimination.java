package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.CompileLog;
import dk.camelot64.kickc.asm.AsmInstruction;
import dk.camelot64.kickc.asm.AsmLabel;
import dk.camelot64.kickc.asm.AsmLine;
import dk.camelot64.kickc.asm.AsmProgram;

import java.util.ArrayList;
import java.util.List;

/** Optimize assembler code by removing jumps to labels immediately following the jump */
public class Pass4NextJumpElimination extends Pass4AsmOptimization {

   public Pass4NextJumpElimination(AsmProgram program, CompileLog log) {
      super(program, log);
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
