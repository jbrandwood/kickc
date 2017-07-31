package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.CompileLog;
import dk.camelot64.kickc.icl.ControlFlowGraph;
import dk.camelot64.kickc.icl.Program;
import dk.camelot64.kickc.icl.ProgramScope;

/** Base class for a compiler pass */
public class Pass2Base {


   private Program program;

   public Pass2Base(Program program) {
      this.program = program;
   }

   public CompileLog getLog() {
      return program.getLog();
   }

   public ControlFlowGraph getGraph() {
      return program.getGraph();
   }

   public ProgramScope getSymbols() {
      return program.getScope();
   }

   public Program getProgram() {
      return program;
   }

}
