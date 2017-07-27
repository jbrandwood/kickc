package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.CompileLog;
import dk.camelot64.kickc.icl.*;

import java.util.*;

/**
 * Finds the depth of loops in the control flow graph.
 * Uses the call graph and natural loops of the control flow graph.
 */
public class Pass3LoopDepthAnalysis {

   private Program program;
   private CompileLog log;

   public Pass3LoopDepthAnalysis(Program program, CompileLog log) {
      this.program = program;
      this.log = log;
   }

   public Program getProgram() {
      return program;
   }

   public CompileLog getLog() {
      return log;
   }

   /**
    * Finds the depth of loops in the control flow graph.
    * Uses the call graph and natural loops of the control flow graph.
    */
   public void findLoopDepths() {
      CallGraph callGraph = program.getGraph().getCallGraph();
      NaturalLoopSet loopSet = program.getGraph().getLoopSet();







   }


}
