package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.CompileLog;
import dk.camelot64.kickc.model.ControlFlowGraph;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.ProgramScope;

/** Assertion checking that a pass 2 representation of the program is consistent */
public abstract class Pass2SsaAssertion {

   private Program program;

   public Pass2SsaAssertion(Program program) {
      this.program = program;
   }

   public ControlFlowGraph getGraph() {
      return program.getGraph();
   }

   public ProgramScope getSymbols() {
      return program.getScope();
   }

   public CompileLog getLog() {
      return program.getLog();
   }

   public Program getProgram() {
      return program;
   }

   public abstract void check() throws AssertionFailed;

   public static class AssertionFailed extends RuntimeException {
      public AssertionFailed(String message) {
         super(message);
      }
   }

}
