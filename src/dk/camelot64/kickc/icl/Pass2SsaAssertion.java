package dk.camelot64.kickc.icl;

/** Assertion checking that a pass 2 representation of the program is consistent */
public abstract class Pass2SsaAssertion {

   private ControlFlowGraph graph;
   private Scope scope;

   public Pass2SsaAssertion(ControlFlowGraph graph, Scope scope) {
      this.graph = graph;
      this.scope = scope;
   }

   public ControlFlowGraph getGraph() {
      return graph;
   }

   public Scope getSymbols() {
      return scope;
   }

   public abstract void check() throws AssertionFailed;

   public static class AssertionFailed extends RuntimeException {
      public AssertionFailed(String message) {
         super(message);
      }
   }

}
