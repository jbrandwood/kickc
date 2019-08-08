package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.asm.AsmChunk;
import dk.camelot64.kickc.asm.AsmComment;
import dk.camelot64.kickc.asm.AsmInstruction;
import dk.camelot64.kickc.asm.AsmLine;
import dk.camelot64.kickc.model.Program;

import java.util.ListIterator;

/**
 * Optimize assembler code by removing anything following an RTS or JMP (meaning they will never execute.) - until the next label/scope occurs.
 * Such JMP's can occur when double JMP's are eliminated
 */
public class Pass5UnreachableCodeElimination extends Pass5AsmOptimization {

   public Pass5UnreachableCodeElimination(Program program) {
      super(program);
   }

   public boolean optimize() {
      boolean optimized = false;

      // Find RTS/JMP followed by code
      boolean afterExit = false;
      for(AsmChunk chunk : getAsmProgram().getChunks()) {
         ListIterator<AsmLine> lineIt = chunk.getLines().listIterator();
         while(lineIt.hasNext()) {
            AsmLine line = lineIt.next();
            if(line instanceof AsmInstruction) {
               if(afterExit) {
                  getLog().append("Removing unreachable instruction " + line.toString());
                  lineIt.remove();
                  optimized = true;
               } else {
                  AsmInstruction asmInstruction = (AsmInstruction) line;
                  if(asmInstruction.getType().getMnemnonic().equals("rts") || asmInstruction.getType().getMnemnonic().equals("jmp")) {
                     afterExit = true;
                  }
               }
            } else if(line instanceof AsmComment) {
               // ignore comments
            } else {
               afterExit = false;
            }
         }
      }

      return optimized;
   }
}
