package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.icl.*;

/** Finds the call graph for the control flow graph - identifies all calls in all scopes and creates a graph from these. */
public class Pass3CallGraphAnalysis extends Pass2Base {


   public Pass3CallGraphAnalysis(Program program) {
      super(program);
   }

   public void findCallGraph() {
      CallGraph callGraph = new CallGraph();
      for (ControlFlowBlock block : getGraph().getAllBlocks()) {
         LabelRef scopeRef = getScopeRef(block, getProgram());
         for (Statement statement : block.getStatements()) {
            if(statement instanceof StatementCall) {
               ProcedureRef procedure = ((StatementCall) statement).getProcedure();
               LabelRef procedureLabel = procedure.getLabelRef();
               CallGraph.CallBlock callBlock = callGraph.getOrCreateCallBlock(scopeRef);
               callBlock.addCall(procedureLabel, (StatementCall) statement);
            }
         }
      }
      getProgram().setCallGraph(callGraph);
   }

   /**
    * Gets a label reference representing the scope of a block
    *
    * @param block The block
    * @return The label of the scope containing the block. The outermost scope has a label containing an empty string.
    */
   public static LabelRef getScopeRef(ControlFlowBlock block, Program program) {
      Symbol blockSymbol = program.getScope().getSymbol(block.getLabel());
      LabelRef scopeRef;
      if(blockSymbol instanceof Procedure) {
         scopeRef = ((Procedure) blockSymbol).getRef().getLabelRef();
      }  else {
         Scope blockScope = blockSymbol.getScope();
         scopeRef = new LabelRef(blockScope.getFullName());
      }
      return scopeRef;
   }

}
