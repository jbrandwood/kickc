package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementCall;
import dk.camelot64.kickc.model.symbols.CallingScope;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.symbols.Scope;
import dk.camelot64.kickc.model.symbols.Symbol;
import dk.camelot64.kickc.model.values.CallingScopeRef;
import dk.camelot64.kickc.model.values.ProcedureRef;

/** Finds the call graph for the control flow graph - identifies all calls in all scopes and creates a graph from these. */
public class Pass3CallGraphAnalysis extends Pass2Base {

   public Pass3CallGraphAnalysis(Program program) {
      super(program);
   }

   /**
    * Gets the calling scope reference representing a block
    *
    * @param block The block
    * @return The calling scope containing the block.
    */
   public static CallingScopeRef getCallingScopeRef(ControlFlowBlock block, Program program) {
      Symbol blockSymbol = program.getScope().getSymbol(block.getLabel());
      CallingScopeRef scopeRef;
      if(blockSymbol instanceof Procedure) {
         scopeRef = (CallingScopeRef) blockSymbol.getRef();
      } else {
         Scope blockScope = blockSymbol.getScope();
         while(!(blockScope instanceof CallingScope)) {
            blockScope = blockScope.getScope();
         }
         scopeRef = (CallingScopeRef) blockScope.getRef();
      }
      return scopeRef;
   }

   public void findCallGraph() {
      CallGraph callGraph = new CallGraph();
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         CallingScopeRef scopeRef = getCallingScopeRef(block, getProgram());
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementCall) {
               ProcedureRef procedure = ((StatementCall) statement).getProcedure();
               CallGraph.CallBlock callBlock = callGraph.getOrCreateCallBlock(scopeRef);
               callBlock.addCall(procedure, (StatementCall) statement);
            }
         }
      }
      getProgram().setCallGraph(callGraph);
   }

}
