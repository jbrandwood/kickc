package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.CompileLog;
import dk.camelot64.kickc.icl.*;

/** Finds the call graph for the control flow graph - identifies all calls in all scopes and creates a graph from these. */
public class Pass3CallGraphAnalysis {

   private Program program;
   private CompileLog log;

   public Pass3CallGraphAnalysis(Program program, CompileLog log) {
      this.program = program;
      this.log = log;
   }

   public Program getProgram() {
      return program;
   }

   public CompileLog getLog() {
      return log;
   }

   public void findCallGraph() {
      CallGraph callGraph = new CallGraph();

      for (ControlFlowBlock block : program.getGraph().getAllBlocks()) {
         Symbol blockSymbol = program.getScope().getSymbol(block.getLabel());
         LabelRef scopeRef;
         if(blockSymbol instanceof Procedure) {
            scopeRef = ((Procedure) blockSymbol).getRef().getLabelRef();
         }  else {
            Scope blockScope = blockSymbol.getScope();
            scopeRef = new LabelRef(blockScope.getFullName());
         }
         for (Statement statement : block.getStatements()) {
            if(statement instanceof StatementCall) {
               ProcedureRef procedure = ((StatementCall) statement).getProcedure();
               LabelRef procedureLabel = procedure.getLabelRef();
               CallGraph.CallBlock callBlock = callGraph.getOrCreateCallBlock(scopeRef);
               callBlock.addCall(procedureLabel, (StatementCall) statement);
            }
         }
      }
      program.getGraph().setCallGraph(callGraph);
   }

}
