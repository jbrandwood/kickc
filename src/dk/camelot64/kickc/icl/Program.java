package dk.camelot64.kickc.icl;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;

/** A KickC Intermediate Compiler Language (ICL) Program */
public class Program {
   /** The main scope. */
   private Scope scope;
   /** The control flow graph. */
   private ControlFlowGraph graph;

   @JsonCreator
   public Program(
         @JsonProperty("scope") Scope scope,
         @JsonProperty("graph") ControlFlowGraph graph) {
      this.scope = scope;
      this.graph = graph;
   }

   public Scope getScope() {
      return scope;
   }

   public void setScope(Scope scope) {
      this.scope = scope;
   }

   public ControlFlowGraph getGraph() {
      return graph;
   }

   public void setGraph(ControlFlowGraph graph) {
      this.graph = graph;
   }
}
