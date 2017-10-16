package dk.camelot64.kickc.passes;

/**
 * Find effective alive intervals for all variables in all statements. Add the intervals to the Program.
 */
import dk.camelot64.kickc.icl.*;

import java.util.*;

public class Pass3LiveRangesEffectiveAnalysis extends Pass2Base {

   public Pass3LiveRangesEffectiveAnalysis(Program program) {
      super(program);
   }

   public void findLiveRangesEffective() {
      LiveRangeVariablesEffective aliveEffective = findAliveEffective(getProgram());
      getProgram().setLiveRangeVariablesEffective(aliveEffective);
      //getLog().append("Calculated effective variable live ranges");
   }


   private LiveRangeVariablesEffective findAliveEffective(Program program) {
      LiveRangeVariables liveRangeVariables = program.getLiveRangeVariables();
      Map<Integer, Collection<VariableRef>> effectiveLiveVariables = new HashMap<>();
      for (ControlFlowBlock block : program.getGraph().getAllBlocks()) {
         for (Statement statement : block.getStatements()) {
            Collection<VariableRef> aliveEffective = findAliveEffective( liveRangeVariables, statement);
            effectiveLiveVariables.put(statement.getIndex(), aliveEffective);
         }
      }
      return new LiveRangeVariablesEffective(effectiveLiveVariables);
   }

   /**
    * Get all variables alive at a statement.
    * If the statement is inside a method this also includes all variables alive at the exit of the calls.
    * <p>
    * This method requires a number of other analysis to be present and updated in the (global) program - especailly the Call Graph.
    * </p>
    * @param statement The statement to examine
    * @return All variables alive at the statement
    */
   private Collection<VariableRef> findAliveEffective(LiveRangeVariables liveRangeVariables, Statement statement) {
      // Get variables alive from live range analysis
      Collection<VariableRef> effectiveAlive = new LinkedHashSet<>();
      effectiveAlive.addAll(liveRangeVariables.getAlive(statement));
      // If the statement is inside a method recurse back to all calls
      // For each call add the variables alive after the call that are not referenced (used/defined) inside the method
      ControlFlowBlock block = getProgram().getGraph().getBlockFromStatementIdx(statement.getIndex());
      ScopeRef scopeRef = block.getScope();
      Scope scope = getProgram().getScope().getScope(scopeRef);
      if (scope instanceof Procedure) {
         Procedure procedure = (Procedure) scope;
         Collection<CallGraph.CallBlock.Call> callers =
               getProgram().getCallGraph().getCallers(procedure.getLabel().getRef());
         VariableReferenceInfo referenceInfo = new VariableReferenceInfo(getProgram());
         Collection<VariableRef> referencedInProcedure = referenceInfo.getReferenced(procedure.getRef().getLabelRef());
         for (CallGraph.CallBlock.Call caller : callers) {
            StatementCall callStatement =
                  (StatementCall) getProgram().getGraph().getStatementByIndex(caller.getCallStatementIdx());
            Set<VariableRef> callAliveEffective = new LinkedHashSet<>(findAliveEffective(liveRangeVariables, callStatement));
            // Clear out any variables referenced in the method
            callAliveEffective.removeAll(referencedInProcedure);
            effectiveAlive.addAll(callAliveEffective);
         }
      }
      return effectiveAlive;
   }


}
