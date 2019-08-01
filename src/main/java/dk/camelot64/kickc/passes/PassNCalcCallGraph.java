package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CallGraph;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementCall;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.symbols.Scope;
import dk.camelot64.kickc.model.symbols.Symbol;
import dk.camelot64.kickc.model.values.ProcedureRef;
import dk.camelot64.kickc.model.values.ScopeRef;

/** Finds the call graph for the control flow graph - identifies all calls in all scopes and creates a graph from these. */
public class PassNCalcCallGraph extends PassNCalcBase<CallGraph> {

   public PassNCalcCallGraph(Program program) {
      super(program);
   }

   public CallGraph calculate() {
      CallGraph callGraph = new CallGraph();
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         ScopeRef scopeRef = getScopeRef(block, getProgram());
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementCall) {
               ProcedureRef procedure = ((StatementCall) statement).getProcedure();
               CallGraph.CallBlock callBlock = callGraph.getOrCreateCallBlock(scopeRef);
               callBlock.addCall(procedure, (StatementCall) statement);
            }
         }
      }
      return callGraph;
   }

   /**
    * Gets a reference to the scope of a block
    *
    * @param block The block
    * @return The scope containing the block. The outermost scope has a label containing an empty string.
    */
   public static ScopeRef getScopeRef(ControlFlowBlock block, Program program) {
      Symbol blockSymbol = program.getScope().getSymbol(block.getLabel());
      if(blockSymbol instanceof Procedure) {
         return ((Procedure) blockSymbol).getRef();
      } else {
         Scope blockScope = blockSymbol.getScope();
         return blockScope.getRef();
      }
   }


}
