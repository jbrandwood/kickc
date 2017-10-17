package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ControlFlowGraph;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.ProgramScope;

/** Assertion checking that a pass 2 representation of the program is consistent */
public abstract class Pass2SsaAssertion {

   private ControlFlowGraph graph;
   private ProgramScope programScope;

   public Pass2SsaAssertion(Program program) {
      this.graph = program.getGraph();
      this.programScope = program.getScope();
   }

   public ControlFlowGraph getGraph() {
      return graph;
   }

   public ProgramScope getSymbols() {
      return programScope;
   }

   public abstract void check() throws AssertionFailed;

   public static class AssertionFailed extends RuntimeException {
      public AssertionFailed(String message) {
         super(message);
      }
   }

}
