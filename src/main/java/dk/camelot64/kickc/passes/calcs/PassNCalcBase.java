package dk.camelot64.kickc.passes.calcs;

import dk.camelot64.kickc.CompileLog;
import dk.camelot64.kickc.model.ControlFlowGraph;
import dk.camelot64.kickc.model.Graph;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.symbols.ProgramScope;

/**
 * Pass N Calculation base class
 */
public abstract class PassNCalcBase<Data> {

   private Program program;

   public PassNCalcBase(Program program) {
      this.program = program;
   }

   public abstract Data calculate();

   public Program getProgram() {
      return program;
   }

   public ProgramScope getScope() {
      return program.getScope();
   }

   public CompileLog getLog() {
      return program.getLog();
   }

   public Graph getGraph() {
      return program.getGraph();
   }

}
