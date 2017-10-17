package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.CompileLog;
import dk.camelot64.kickc.asm.AsmLine;
import dk.camelot64.kickc.asm.AsmProgram;
import dk.camelot64.kickc.asm.AsmSegment;
import dk.camelot64.kickc.model.Program;

import java.util.Collection;
import java.util.Iterator;
import java.util.List;

/**
 * Optimization performed on Assembler Code (Asm Code).
 * Optimizations are performed repeatedly until none of them yield any result
 **/
public abstract class Pass5AsmOptimization {

   private Program program;

   public Pass5AsmOptimization(Program program) {
      this.program = program;
   }

   /**
    * Attempt to perform optimization.
    *
    * @return true if an optimization was performed. false if no optimization was possible.
    */
   public abstract boolean optimize();

   public AsmProgram getAsmProgram() {
      return program.getAsm();
   }

   public CompileLog getLog() {
      return program.getLog();
   }

   public void remove(List<AsmLine> remove) {
      Collection<AsmSegment> segments = getAsmProgram().getSegments();
      for (AsmSegment segment : segments) {
         for (Iterator<AsmLine> iterator = segment.getLines().iterator(); iterator.hasNext(); ) {
            AsmLine line = iterator.next();
            if (remove.contains(line)) {
               getLog().append("Removing instruction " + line.getAsm());
               iterator.remove();
            }
         }
      }
   }
}
