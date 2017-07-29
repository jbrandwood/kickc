package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.CompileLog;
import dk.camelot64.kickc.icl.ControlFlowBlock;
import dk.camelot64.kickc.icl.Program;
import dk.camelot64.kickc.icl.Statement;

/**
 * Finds register weights for all variables.
 *
 * The register weight signifies how beneficial it would be for the variable to assigned to a register (instead of zero page).
 *
 * Uses Loop Depth and Live Ranges plus the statements of the control flow graph.
 * <p>
 * Based on ComputeWeight from http://compilers.cs.ucla.edu/fernando/projects/soc/reports/short_tech.pdf
 */
public class Pass3VariableRegisterWeightAnalysis {

   private Program program;
   private CompileLog log;

   public Pass3VariableRegisterWeightAnalysis(Program program, CompileLog log) {
      this.program = program;
      this.log = log;
   }

   public Program getProgram() {
      return program;
   }

   public CompileLog getLog() {
      return log;
   }

   /** Find register weights for all variables    */
   public void findWeights() {

      for (ControlFlowBlock block : program.getGraph().getAllBlocks()) {
         for (Statement statement : block.getStatements()) {



         }
      }


   }


}
