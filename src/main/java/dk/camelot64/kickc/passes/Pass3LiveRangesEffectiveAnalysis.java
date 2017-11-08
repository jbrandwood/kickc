package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;

import java.util.*;

/**
 * Find effective alive intervals for all variables in all statements. Add the intervals to the Program.
 */
public class Pass3LiveRangesEffectiveAnalysis extends Pass2Base {

   /**
    * Call-paths for all procedures.
    */
   private Map<ProcedureRef, LiveRangeVariablesEffective.CallPaths> procedureCallPaths;

   /**
    * Normal variable live ranges.
    */
   private LiveRangeVariables liveRangeVariables;

   /**
    * Information about which procedures reference which variables.
    */
   private VariableReferenceInfo referenceInfo;


   public Pass3LiveRangesEffectiveAnalysis(Program program) {
      super(program);
   }

   public void findLiveRangesEffective() {
      this.liveRangeVariables = getProgram().getLiveRangeVariables();
      this.referenceInfo = new VariableReferenceInfo(getProgram());
      this.procedureCallPaths = new LinkedHashMap<>();
      populateProcedureCallPaths();
      LiveRangeVariablesEffective aliveEffective = new LiveRangeVariablesEffective(getProgram(), procedureCallPaths, liveRangeVariables, referenceInfo);
      getProgram().setLiveRangeVariablesEffective(aliveEffective);
      //getLog().append("Calculated effective variable live ranges");
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

   private void populateProcedureCallPaths() {
      this.procedureCallPaths = new LinkedHashMap<>();
      Collection<Procedure> procedures = getProgram().getScope().getAllProcedures(true);
      for (Procedure procedure : procedures) {
         populateProcedureCallPaths(procedure);
      }
   }

   private void populateProcedureCallPaths(Procedure procedure) {
      ProcedureRef procedureRef = procedure.getRef();
      LiveRangeVariablesEffective.CallPaths callPaths = procedureCallPaths.get(procedureRef);
      if (callPaths == null) {
         callPaths = new LiveRangeVariablesEffective.CallPaths(procedureRef);
         Collection<CallGraph.CallBlock.Call> callers =
               getProgram().getCallGraph().getCallers(procedure.getLabel().getRef());
         for (CallGraph.CallBlock.Call caller : callers) {
            // Each caller creates its own call-paths
            StatementCall callStatement =
                  (StatementCall) getProgram().getGraph().getStatementByIndex(caller.getCallStatementIdx());
            ControlFlowBlock callBlock = getProgram().getGraph().getBlockFromStatementIdx(callStatement.getIndex());
            ScopeRef callScopeRef = callBlock.getScope();
            Scope callScope = getProgram().getScope().getScope(callScopeRef);
            if (callScope instanceof Procedure) {
               // Found calling procedure!
               Procedure callerProcedure = (Procedure) callScope;
               // Make sure we have populated the call-paths of the calling procedure
               populateProcedureCallPaths(callerProcedure);
               // Find variables referenced in caller procedure
               Collection<VariableRef> referencedInCaller = referenceInfo.getReferenced(callerProcedure.getRef().getLabelRef());
               // For each caller path - create a new call-path
               LiveRangeVariablesEffective.CallPaths callerPaths = procedureCallPaths.get(callerProcedure.getRef());
               for (LiveRangeVariablesEffective.CallPath callerPath : callerPaths.getCallPaths()) {
                  ArrayList<CallGraph.CallBlock.Call> path = new ArrayList<>(callerPath.getPath());
                  path.add(caller);
                  Collection<VariableRef> alive = new LinkedHashSet<>();
                  alive.addAll(callerPath.getAlive());
                  alive.removeAll(referencedInCaller);
                  alive.addAll(liveRangeVariables.getAlive(callStatement));
                  Pass2AliasElimination.Aliases aliases = getCallAliases(procedure, callBlock, callerPath);
                  LiveRangeVariablesEffective.CallPath callPath = new LiveRangeVariablesEffective.CallPath(path, alive, aliases);
                  callPaths.add(callPath);
               }
            } else {
               // main() call outside procedure scope - create initial call-path.
               ArrayList<CallGraph.CallBlock.Call> rootPath = new ArrayList<>();
               rootPath.add(caller);
               ArrayList<VariableRef> rootAlive = new ArrayList<>();
               // Initialize with global cross-scope aliases
               Pass2AliasElimination.Aliases rootAliases = new Pass2AliasElimination.Aliases();
               LiveRangeVariablesEffective.CallPath rootCallPath = new LiveRangeVariablesEffective.CallPath(rootPath, rootAlive, rootAliases);
               callPaths.add(rootCallPath);
            }
         }
         procedureCallPaths.put(procedureRef, callPaths);
      }
   }

   /**
    * Find aliases defined when taking a specific call - meaning call parameters that have specific values when taking the specific call.
    * @param procedurePhiBlock The phi-block of the called procedure
    * @param callBlock The block performing the call
    * @param callerPath The call-path from main() to the calling procedure. (contains aliases for all preceding calls)
    * @return Aliases defined by the specific call.
    */
   private Pass2AliasElimination.Aliases getCallAliases(Procedure procedure, ControlFlowBlock callBlock, LiveRangeVariablesEffective.CallPath callerPath) {
      ControlFlowBlock procedureBlock = getProgram().getGraph().getBlock(procedure.getLabel().getRef());
      StatementPhiBlock procedurePhiBlock = null;
      if(procedureBlock.hasPhiBlock()) {
         procedurePhiBlock = procedureBlock.getPhiBlock();
      }
      Pass2AliasElimination.Aliases aliases = new Pass2AliasElimination.Aliases(callerPath.getAliases());
      // Find aliases inside the phi-block of the called method
      if(procedurePhiBlock!=null) {
         for (StatementPhiBlock.PhiVariable phiVariable : procedurePhiBlock.getPhiVariables()) {
            RValue phiRvalue = phiVariable.getrValue(callBlock.getLabel());
            if (phiRvalue instanceof VariableRef) {
               aliases.add(phiVariable.getVariable(), (VariableRef) phiRvalue);
            }
         }
      }
      // Find call parameter aliasses in the calling block before the call
      for (Statement statement : callBlock.getStatements()) {
         if(statement instanceof StatementAssignment) {
            StatementAssignment assignment = (StatementAssignment) statement;
            LValue lValue = assignment.getlValue();
            if(lValue instanceof VariableRef) {
               Variable lValueVar = getProgram().getScope().getVariable((VariableRef) lValue);
               if(lValueVar.getScope().equals(procedure)) {
                  // Assigning into the procedure scope
                  if(assignment.getrValue1()==null && assignment.getOperator()==null && assignment.getrValue2() instanceof VariableRef) {
                     aliases.add((VariableRef) lValue, (VariableRef) assignment.getrValue2());
                  }
               }
            }
         }
      }
      return aliases;
   }


}
