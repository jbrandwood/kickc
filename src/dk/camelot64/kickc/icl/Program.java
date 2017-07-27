package dk.camelot64.kickc.icl;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;

/** A KickC Intermediate Compiler Language (ICL) Program */
public class Program {

   /** The main scope. */
   private ProgramScope scope;
   /** The control flow graph. */
   private ControlFlowGraph graph;

   @JsonCreator
   public Program(
         @JsonProperty("scope") ProgramScope scope,
         @JsonProperty("graph") ControlFlowGraph graph) {
      this.scope = scope;
      this.graph = graph;
   }

   public ProgramScope getScope() {
      return scope;
   }

   public void setScope(ProgramScope scope) {
      this.scope = scope;
   }

   public ControlFlowGraph getGraph() {
      return graph;
   }

   public void setGraph(ControlFlowGraph graph) {
      this.graph = graph;
   }

   @Override
   public boolean equals(Object o) {
      if (this == o) return true;
      if (o == null || getClass() != o.getClass()) return false;

      Program program = (Program) o;

      if (scope != null ? !scope.equals(program.scope) : program.scope != null) return false;
      return graph != null ? graph.equals(program.graph) : program.graph == null;
   }

   @Override
   public int hashCode() {
      int result = scope != null ? scope.hashCode() : 0;
      result = 31 * result + (graph != null ? graph.hashCode() : 0);
      return result;
   }
}
