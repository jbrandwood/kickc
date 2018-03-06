package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementCall;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.symbols.Scope;
import dk.camelot64.kickc.model.symbols.Symbol;
import dk.camelot64.kickc.model.values.LabelRef;
import dk.camelot64.kickc.model.values.ProcedureRef;

/** Finds the call graph for the control flow graph - identifies all calls in all scopes and creates a graph from these. */
public class Pass3CallGraphAnalysis extends Pass2Base {


   public Pass3CallGraphAnalysis(Program program) {
      super(program);
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
      } else {
         Scope blockScope = blockSymbol.getScope();
         scopeRef = new LabelRef(blockScope.getFullName());
      }
      return scopeRef;
   }

   public void findCallGraph() {
      CallGraph callGraph = new CallGraph();
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         LabelRef scopeRef = getScopeRef(block, getProgram());
         for(Statement statement : block.getStatements()) {
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

}
