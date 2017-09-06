package dk.camelot64.kickc.icl;

import java.util.*;

/** Live ranges for all variables.
 * Created by {@link dk.camelot64.kickc.passes.Pass3CallGraphAnalysis}
 */
public class LiveRangeVariables {

   private LinkedHashMap<VariableRef, LiveRange> liveRanges;

   private Program program;

   public LiveRangeVariables(Program program) {
      this.liveRanges = new LinkedHashMap<>();
      this.program = program;
   }

   /** Add a single statement to the live range of a variable.
    *
    * @param variable The variable
    * @param statement The statement to add
    * @return true if a live range was modified by the addition
    */
   public boolean addAlive(VariableRef variable, Statement statement) {
      LiveRange liveRange = liveRanges.get(variable);
      if (liveRange == null) {
         liveRange = new LiveRange();
         liveRanges.put(variable, liveRange);
      }
      return liveRange.add(statement);
   }

   /**
    * Add an empty alive range for a variable
    * @param variable The variable
    */
   public void addEmptyAlive(VariableRef variable) {
      LiveRange liveRange = liveRanges.get(variable);
      if (liveRange == null) {
         liveRange = new LiveRange();
         liveRanges.put(variable, liveRange);
      }
   }

   /**
    * Get all variables alive at a specific statement
    * @param statement The statement
    * @return List of all live variables.
    */
   public List<VariableRef> getAlive(Statement statement) {
      ArrayList<VariableRef> aliveVars = new ArrayList<>();
      for (VariableRef variable : liveRanges.keySet()) {
         LiveRange liveRange = liveRanges.get(variable);
         if(liveRange.contains(statement)) {
            aliveVars.add(variable);
         }
      }
      return aliveVars;
   }

   /**
    * Get the alive range of a variable
    * @param variable The variable reference
    * @return The alive range for the variable
    */
   public LiveRange getLiveRange(VariableRef variable) {
      return liveRanges.get(variable);
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
   public Collection<VariableRef> getAliveEffective(Statement statement) {
      // Get variables alive from live range analysis
      Collection<VariableRef> effectiveAlive = new LinkedHashSet<>();
      effectiveAlive.addAll(getAlive(statement));
      // If the statement is inside a method recurse back to all calls
      // For each call add the variables alive after the call that are not referenced (used/defined) inside the method
      ControlFlowBlock block = program.getGraph().getBlockFromStatementIdx(statement.getIndex());
      ScopeRef scopeRef = block.getScope();
      Scope scope = program.getScope().getScope(scopeRef);
      if (scope instanceof Procedure) {
         Procedure procedure = (Procedure) scope;
         Collection<CallGraph.CallBlock.Call> callers =
               program.getCallGraph().getCallers(procedure.getLabel().getRef());
         VariableReferenceInfo referenceInfo = new VariableReferenceInfo(program);
         Collection<VariableRef> referencedInProcedure = referenceInfo.getReferenced(procedure.getRef().getLabelRef());
         for (CallGraph.CallBlock.Call caller : callers) {
            StatementCall callStatement =
                  (StatementCall) program.getGraph().getStatementByIndex(caller.getCallStatementIdx());
            Set<VariableRef> callAliveEffective = new LinkedHashSet<>(getAliveEffective(callStatement));
            // Clear out any variables referenced in the method
            callAliveEffective.removeAll(referencedInProcedure);
            effectiveAlive.addAll(callAliveEffective);
         }
      }
      return effectiveAlive;
   }

}
