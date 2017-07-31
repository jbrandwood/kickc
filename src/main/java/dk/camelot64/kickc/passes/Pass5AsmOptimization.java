package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.CompileLog;
import dk.camelot64.kickc.asm.AsmLine;
import dk.camelot64.kickc.asm.AsmProgram;
import dk.camelot64.kickc.icl.Program;

import java.util.Iterator;
import java.util.List;

/** Optimization performed on Assembler Code (Asm Code).
 * Optimizations are performed repeatedly until none of them yield any result
 **/
public abstract class Pass5AsmOptimization {

   protected CompileLog log;
   private Program program;

   public Pass5AsmOptimization(Program program, CompileLog log) {
      this.program = program;
      this.log = log;
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
      return log;
   }

   public void remove(List<AsmLine> remove) {
      for (Iterator<AsmLine> iterator = getAsmProgram().getLines().iterator(); iterator.hasNext(); ) {
         AsmLine line = iterator.next();
         if (remove.contains(line)) {
            log.append("Removing instruction "+line.getAsm());
            iterator.remove();
         }
      }
   }
}
