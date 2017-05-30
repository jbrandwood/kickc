package dk.camelot64.kickc.icl;

import dk.camelot64.kickc.asm.AsmLine;
import dk.camelot64.kickc.asm.AsmProgram;

import java.util.Iterator;
import java.util.List;

/** Optimization performed on Assembler Code (Asm Code).
 * Optimizations are performed repeatedly until none of them yield any result
 **/
public abstract class Pass4AsmOptimization {

   private AsmProgram program;

   public Pass4AsmOptimization(AsmProgram program) {
      this.program = program;
   }

   /**
    * Attempt to perform optimization.
    *
    * @return true if an optimization was performed. false if no optimization was possible.
    */
   public abstract boolean optimize();

   public AsmProgram getProgram() {
      return program;
   }

   public void remove(List<AsmLine> remove) {
      for (Iterator<AsmLine> iterator = program.getLines().iterator(); iterator.hasNext(); ) {
         AsmLine line = iterator.next();
         if (remove.contains(line)) {
            System.out.println("Removing instruction "+line.getAsm());
            iterator.remove();
         }
      }
   }
}
