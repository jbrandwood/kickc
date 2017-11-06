package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;

import java.util.*;

/**
 * Find effective alive intervals for all variables in all statements. Add the intervals to the Program.
 */
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
      Map<Integer, LiveRangeVariablesEffective.AliveCombinations> effectiveLiveVariablesCombinations = new HashMap<>();
      for (ControlFlowBlock block : program.getGraph().getAllBlocks()) {
         for (Statement statement : block.getStatements()) {
            Collection<Collection<VariableRef>> statementAliveCombinations = findAliveEffective(liveRangeVariables, statement);
            LiveRangeVariablesEffective.AliveCombinations aliveCombinations = new LiveRangeVariablesEffective.AliveCombinations(statementAliveCombinations);
            effectiveLiveVariablesCombinations.put(statement.getIndex(), aliveCombinations);
         }
      }
      return new LiveRangeVariablesEffective(effectiveLiveVariablesCombinations);
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
   private Collection<Collection<VariableRef>> findAliveEffective(LiveRangeVariables liveRangeVariables, Statement statement) {
      Set<Collection<VariableRef>> combinations = new LinkedHashSet<>();
      // Get variables alive from live range analysis
      Collection<VariableRef> effectiveAlive = liveRangeVariables.getAlive(statement);
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
            // Each caller creates its own combinations
            StatementCall callStatement =
                  (StatementCall) getProgram().getGraph().getStatementByIndex(caller.getCallStatementIdx());
            Collection<Collection<VariableRef>> callerCombinations = findAliveEffective(liveRangeVariables, callStatement);
            for (Collection<VariableRef> callerCombination : callerCombinations) {
               LinkedHashSet<VariableRef> combination = new LinkedHashSet<>();
               // Add alive at call
               combination.addAll(callerCombination);
               // Clear out any variables referenced in the method
               combination.removeAll(referencedInProcedure);
               // Add alive at statement
               combination.addAll(effectiveAlive);
               // Add combination
               combinations.add(combination);
            }
         }
      }
      if(combinations.size()==0) {
         // Add the combination at the current statement if no other combinations have been created
         combinations.add(effectiveAlive);
      }
      return combinations;
   }

}
