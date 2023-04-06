package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.CompileLog;
import dk.camelot64.kickc.model.ControlFlowGraph;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.symbols.ProgramScope;

/** Base class for a compiler pass */
public class Pass2Base {

   private Program program;

   public Pass2Base(Program program) {
      this.program = program;
   }

   public CompileLog getLog() {
      return program.getLog();
   }

   public ProgramScope getSymbols() {
      return program.getScope();
   }

   public Program getProgram() {
      return program;
   }

}
