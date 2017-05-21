package dk.camelot64.kickc.icl;

import dk.camelot64.kickc.asm.AsmInstruction;
import dk.camelot64.kickc.asm.AsmLabel;
import dk.camelot64.kickc.asm.AsmLine;
import dk.camelot64.kickc.asm.AsmProgram;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

/** Optimize assembler code by removing jumps to labels immediately following the jump */
public class Pass5NextJumpElimination {

   private AsmProgram program;

   public Pass5NextJumpElimination(AsmProgram program) {
      this.program = program;
   }

   public boolean optimize() {
      List<AsmLine> remove = new ArrayList<>();
      AsmInstruction candidate = null;
      for (AsmLine line : program.getLines()) {
         if(candidate!=null) {
            if(line instanceof AsmLabel) {
               if(((AsmLabel) line).getLabel().equals(candidate.getParameter())) {
                  remove.add(candidate);
                  candidate = null;
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
      for (Iterator<AsmLine> iterator = program.getLines().iterator(); iterator.hasNext(); ) {
         AsmLine line = iterator.next();
         if (remove.contains(line)) {
            System.out.println("Removing jump to next instruction "+line.getAsm());
            iterator.remove();
         }
      }
      return remove.size()>0;
   }
}
