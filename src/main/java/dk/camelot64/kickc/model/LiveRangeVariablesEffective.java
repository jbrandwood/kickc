package dk.camelot64.kickc.model;

import dk.camelot64.kickc.passes.Pass2AliasElimination;

import java.util.*;

/**
 * Effective variable live ranges for all statements.
 * (Including variables alive in calling methods).
 * Created by {@link dk.camelot64.kickc.passes.Pass3LiveRangesEffectiveAnalysis}
 */
public class LiveRangeVariablesEffective {

   /**
    * The program.
    */
   private Program program;

   /**
    * Call-paths for all procedures.
    */
   private Map<ProcedureRef, CallPaths> procedureCallPaths;

   /**
    * Normal variable live ranges.
    */
   private LiveRangeVariables liveRangeVariables;

   /**
    * Information about which procedures reference which variables.
    */
   private VariableReferenceInfo referenceInfo;

   public LiveRangeVariablesEffective(Program program, Map<ProcedureRef, CallPaths> procedureCallPaths, LiveRangeVariables liveRangeVariables, VariableReferenceInfo referenceInfo) {
      this.program = program;
      this.procedureCallPaths = procedureCallPaths;
      this.liveRangeVariables = liveRangeVariables;
      this.referenceInfo = referenceInfo;
   }

   /**
    * All call-paths leading into a specific procedure.
    */
   public static class CallPaths {
      /**
       * The procedure
       */
      private ProcedureRef procedure;
      /**
       * All call-paths leading into the procedure from the main() procedure.
       */
      private Collection<CallPath> callPaths;

      public CallPaths(ProcedureRef procedure) {
         this.procedure = procedure;
         this.callPaths = new ArrayList<>();
      }

      public ProcedureRef getProcedure() {
         return procedure;
      }

      public Collection<CallPath> getCallPaths() {
         return callPaths;
      }

      public void add(CallPath callPath) {
         this.callPaths.add(callPath);
      }
   }

   /**
    * All variables alive in a specific procedure at a specific call-path.
    * The call-path is th path from the main()-procedure to the procedure in question.
    */
   public static class CallPath {

      /**
       * The path from main() to the procedure. First element is the call to main(), last element is the call to the procedure.
       */
      private List<CallGraph.CallBlock.Call> path;
      /**
       * Alive variables on the call-path. Based on alive vars at each call in the path.
       */
      private Collection<VariableRef> alive;
      /**
       * Alias variables for the innermost call. Variables alias-assigned as part of the innermost call on the path (in parameter assignment or phi block).
       */
      private Pass2AliasElimination.Aliases innerAliases;
      /**
       * Alias variables from the entire call-path. Any variables alias-assigned as part of a call on the path (in parameter assignment or phi block).
       */
      private Pass2AliasElimination.Aliases pathAliases;

      public CallPath(List<CallGraph.CallBlock.Call> path, Collection<VariableRef> alive, Pass2AliasElimination.Aliases innerAliases, Pass2AliasElimination.Aliases pathAliases) {
         this.path = path;
         this.alive = alive;
         this.innerAliases = innerAliases;
         this.pathAliases = pathAliases;
      }

      /**
       * The path from main() to the procedure. First element is the call to main(), last element is the call to the procedure.
       * @return Tha call path
       */
      public List<CallGraph.CallBlock.Call> getPath() {
         return path;
      }

      /**
       * Alive variables on the call-path. Based on alive vars at each call in the path.
       * @return The alive variables
       */
      public Collection<VariableRef> getAlive() {
         return alive;
      }

      /**
       * Alias variables from the entire call-path. Any variables alias-assigned as part of a call on the path (in parameter assignment or phi block).
       * @return The aliases
       */
      public Pass2AliasElimination.Aliases getPathAliases() {
         return pathAliases;
      }

      /**
       * Alias variables for the innermost call. Variables alias-assigned as part of the innermost call on the path (in parameter assignment or phi block).
       * @return The aliases
       */
      public Pass2AliasElimination.Aliases getInnerAliases() {
         return innerAliases;
      }
   }


   /**
    * Get all variables potentially alive at a statement.
    * If the statement is inside a method this also includes all variables alive at the exit of any call.
    * </p>
    *
    * @param statement The statement to examine
    * @return All variables potentially alive at the statement
    */
   public Collection<VariableRef> getAliveEffective(Statement statement) {
      Set<VariableRef> effectiveAliveTotal = new LinkedHashSet<>();
      AliveCombinations aliveCombinations = getAliveCombinations(statement);
      for (CallPath callPath : aliveCombinations.getCallPaths().getCallPaths()) {
         Collection<VariableRef> alive = aliveCombinations.getEffectiveAliveAtStmt(callPath);
         effectiveAliveTotal.addAll(alive);
      }
      return effectiveAliveTotal;
   }

   /**
    * Get all combinations of variables alive at a statement.
    * If the statement is inside a method the different combinations in the result arises from different calls of the method
    * (recursively up til the main()-method.)
    * Each combination includes all variables alive at the exit of any surrounding call.
    * Also includes variable aliases that are part of the parameter assignments to the calls on the path.
    * </p>
    *
    * @param statement The statement to examine
    * @return All combinations of variables alive at the statement
    */
   public AliveCombinations getAliveCombinations(Statement statement) {
      List<VariableRef> aliveAtStmt = liveRangeVariables.getAlive(statement);
      CallPaths callPaths;
      Collection<VariableRef> referencedInProcedure;
      ControlFlowBlock block = program.getGraph().getBlockFromStatementIdx(statement.getIndex());
      ScopeRef scopeRef = block.getScope();
      Scope scope = program.getScope().getScope(scopeRef);
      if (scope instanceof Procedure) {
         Procedure procedure = (Procedure) scope;
         callPaths = procedureCallPaths.get(procedure.getRef());
         referencedInProcedure = referenceInfo.getReferenced(procedure.getRef().getLabelRef());
      } else {
         callPaths = new CallPaths(Procedure.ROOT);
         referencedInProcedure = new ArrayList<>();
      }
      // Examine if the statement is a parameter assignment before a call
      throw new RuntimeException("Examine if the statement is a parameter assignment before a call - and add the inner aliases if it is");

      return new AliveCombinations(callPaths, referencedInProcedure, aliveAtStmt);
   }

   /**
    * Combinations of variables effectively alive at a specific statement.
    * If the statement is inside a method the combinations are the live variables inside the method combined with each calling statements alive vars.
    * As each caller might also be inside a methos there may be a large amount of combinations.
    */
   public static class AliveCombinations {

      /**
       * All call-paths to the procedure containing the statement.
       */
      private CallPaths callPaths;
      /**
       * All variables referenced in the procedure containing the statement.
       */
      private Collection<VariableRef> referencedInProcedure;
      /**
       * Variables alive at the statement inside the procedure.
       */
      private Collection<VariableRef> aliveAtStmt;
      /**
       * If the statement is an assignment to a call parameter this contains the aliases for that specific call.
       */
      private Pass2AliasElimination.Aliases callAliases;

      public AliveCombinations(CallPaths callPaths, Collection<VariableRef> referencedInProcedure, Collection<VariableRef> aliveAtStmt, Pass2AliasElimination.Aliases callAliases) {
         this.callPaths = callPaths;
         this.referencedInProcedure = referencedInProcedure;
         this.aliveAtStmt = aliveAtStmt;
         this.callAliases = callAliases;
      }

      public CallPaths getCallPaths() {
         return callPaths;
      }

      /**
       * Get all variables effective alive at the statement for a specific call path.
       * @param callPath The call path (returned from getCallPaths)
       * @return All variables effectively alive at the statement on the call-path
       */
      public Collection<VariableRef> getEffectiveAliveAtStmt(CallPath callPath) {
         LinkedHashSet<VariableRef> effectiveAlive = new LinkedHashSet<>();
         // Add alive at call
         effectiveAlive.addAll(callPath.getAlive());
         // Clear out any variables referenced in the method
         effectiveAlive.removeAll(referencedInProcedure);
         // Add alive at statement
         effectiveAlive.addAll(aliveAtStmt);
         return effectiveAlive;
      }

      public Pass2AliasElimination.Aliases getEffectiveAliasesAtStmt(CallPath callPath) {
         if(callAliases==null) {
            return callPath.getPathAliases();
         } else {
            Pass2AliasElimination.Aliases aliases = new Pass2AliasElimination.Aliases();
            aliases.addAll(callPath.getPathAliases());
            aliases.addAll(callAliases);
            return aliases;
         }
      }
   }


}
