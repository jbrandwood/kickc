package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.CompileLog;
import dk.camelot64.kickc.model.ControlFlowGraph;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.ProgramScope;

/**
 * Pass 1 (before SSA optimizations) base class
 */
public abstract class Pass1Base {

   private Program program;

   public Pass1Base(Program program) {
      this.program = program;
   }

   /**
    * Execute the step repeatedly until it is done.
    */
   public void execute() {
      boolean again = true;
      while(again) {
         again = step();
      }
   }

   /**
    * Execute the pass 1 step.
    *
    * @return boolean indicating whether the step should be repeated.
    */
   public abstract boolean step();

   public Program getProgram() {
      return program;
   }

   public ProgramScope getScope() {
      return program.getScope();
   }

   public CompileLog getLog() {
      return program.getLog();
   }

   public ControlFlowGraph getGraph() {
      return program.getGraph();
   }


}
