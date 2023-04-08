package dk.camelot64.kickc.model;

import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.symbols.Scope;
import dk.camelot64.kickc.model.values.LabelRef;
import dk.camelot64.kickc.model.values.ProcedureRef;
import dk.camelot64.kickc.model.values.ScopeRef;
import dk.camelot64.kickc.model.values.VariableRef;
import dk.camelot64.kickc.passes.Pass2AliasElimination;
import dk.camelot64.kickc.passes.calcs.PassNCalcLiveRangesEffectiveCallPaths;

import java.util.*;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * Effective variable live ranges for all statements.
 * (Including variables alive in calling methods).
 * Created by {@link PassNCalcLiveRangesEffectiveCallPaths}
 */
public class LiveRangeVariablesEffectiveCallPaths implements LiveRangeVariablesEffective {

   /**
    * The program.
    */
   private Program program;

   /**
    * Call-paths for all procedures.
    */
   private Map<ProcedureRef, CallPaths> procedureCallPaths;

   /** Variables (normally) alive at each statement by index. */
   private Map<Integer, Collection<VariableRef>> statementLiveVariables;

   /**  Information about which procedures reference which variables.   */
   private VariableReferenceInfos referenceInfo;

   /**  Information about which blocks follow other blocks.   */
   private ControlFlowBlockSuccessorClosure blockSuccessorClosure;

   public LiveRangeVariablesEffectiveCallPaths(Program program, Map<ProcedureRef, CallPaths> procedureCallPaths, LiveRangeVariables liveRangeVariables, VariableReferenceInfos referenceInfo, ControlFlowBlockSuccessorClosure blockSuccessorClosure) {
      this.program = program;
      this.procedureCallPaths = procedureCallPaths;
      this.referenceInfo = referenceInfo;
      this.blockSuccessorClosure = blockSuccessorClosure;
      this.statementLiveVariables = new LinkedHashMap<>();
      for(Graph.Block block : program.getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            statementLiveVariables.put(statement.getIndex(), liveRangeVariables.getAlive(statement.getIndex()));
         }
      }
   }

   /** Cached alive effective by statement index. */
   private Map<Integer, Collection<VariableRef>> statementAliveEffective = new LinkedHashMap<>();

   /**
    * Get all variables potentially alive at a statement.
    * If the statement is inside a method this also includes all variables alive at the exit of any call.
    * </p>
    *
    * @param statement The statement to examine
    * @return All variables potentially alive at the statement
    */
   @Override
   public Collection<VariableRef> getAliveEffective(Statement statement) {
      Collection<VariableRef> effectiveAliveTotal = statementAliveEffective.get(statement.getIndex());
      if(effectiveAliveTotal == null) {
         effectiveAliveTotal = new LinkedHashSet<>();
         AliveCombinations aliveCombinations = getAliveCombinations(statement);
         for(AliveCombination combination : aliveCombinations.getAll()) {
            Collection<VariableRef> alive = combination.getEffectiveAliveAtStmt();
            effectiveAliveTotal.addAll(alive);
         }
         statementAliveEffective.put(statement.getIndex(), effectiveAliveTotal);
      }
      return effectiveAliveTotal;
   }

   /** Cached alive combinations. */
   private Map<Integer, AliveCombinationsCallPath> statementAliveCombinations = new LinkedHashMap<>();

   /** Special procedure reference used to represent the ROOT scope during live range analysis. */
   private static final ProcedureRef ROOT_PROCEDURE = new ProcedureRef("");

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
   @Override
   public AliveCombinations getAliveCombinations(Statement statement) {
      AliveCombinationsCallPath stmtCombinations = this.statementAliveCombinations.get(statement.getIndex());
      if(stmtCombinations == null) {
         Collection<VariableRef> aliveAtStmt = statementLiveVariables.get(statement.getIndex());
         CallPaths callPaths;
         Collection<VariableRef> referencedInProcedure;
         Graph.Block block = program.getStatementInfos().getBlock(statement);
         ScopeRef scopeRef = block.getScope();
         Scope scope = program.getScope().getScope(scopeRef);
         if(scope instanceof Procedure) {
            Procedure procedure = (Procedure) scope;
            callPaths = procedureCallPaths.get(procedure.getRef());
            referencedInProcedure = blockSuccessorClosure.getSuccessorClosureReferencedVars(procedure.getRef().getLabelRef(), referenceInfo);
         } else {
            callPaths = new CallPaths(ROOT_PROCEDURE);
            // Interrupt is called outside procedure scope - create initial call-path.
            ArrayList<CallGraph.CallBlock.Call> rootPath = new ArrayList<>();
            ArrayList<VariableRef> rootAlive = new ArrayList<>();
            // Initialize with global cross-scope aliases (assumed empty)
            Pass2AliasElimination.Aliases rootAliases = new Pass2AliasElimination.Aliases();
            LiveRangeVariablesEffectiveCallPaths.CallPath rootCallPath = new LiveRangeVariablesEffectiveCallPaths.CallPath(rootPath, rootAlive, rootAliases, rootAliases);
            callPaths.add(rootCallPath);
            referencedInProcedure = new ArrayList<>();
         }
         Pass2AliasElimination.Aliases callAliases = null;
         // Examine if the statement is a parameter assignment before a call
         LabelRef callSuccessor = block.getCallSuccessor();
         if(callSuccessor != null) {
            ProcedureRef calledRef = new ProcedureRef(callSuccessor.getFullName());
            CallPaths calledRefs = procedureCallPaths.get(calledRef);
            for(CallPath calledPath : calledRefs.getCallPaths()) {
               List<CallGraph.CallBlock.Call> path = calledPath.getPath();
               if(path.size() > 0) {
                  CallGraph.CallBlock.Call lastCall = path.get(path.size() - 1);
                  Integer lastCallStatementIdx = lastCall.getCallStatementIdx();
                  LabelRef lastCallBlockRef = program.getStatementInfos().getBlockRef(lastCallStatementIdx);
                  if(lastCallBlockRef.equals(block.getLabel())) {
                     if(callAliases == null) {
                        // Found a matching call!
                        callAliases = calledPath.getInnerAliases();
                     } else {
                        // Found another matching call!
                        callAliases = new Pass2AliasElimination.Aliases(callAliases);
                        callAliases.addAll(calledPath.getInnerAliases());
                     }
                  }
               }
            }
         }
         stmtCombinations = new AliveCombinationsCallPath(callPaths, referencedInProcedure, aliveAtStmt, callAliases);
         statementAliveCombinations.put(statement.getIndex(), stmtCombinations);
      }
      return stmtCombinations;
   }


   public String getSizeInfo() {
      StringBuilder sizeInfo = new StringBuilder();
      if(this.procedureCallPaths != null) {
         AtomicInteger numCallPaths = new AtomicInteger();
         this.procedureCallPaths.values().forEach(callPaths -> numCallPaths.addAndGet(callPaths.getCallPaths().size()));
         sizeInfo.append("SIZE procedureCallPaths ").append(numCallPaths.get()).append("\n");
      }
      if(this.statementAliveEffective != null) {
         sizeInfo.append("SIZE statementAliveEffective ").append(statementAliveEffective.size()).append(" statements ");
         int sub = 0;
         for(Collection<VariableRef> variableRefs : statementAliveEffective.values()) {
            sub += variableRefs.size();
         }
         sizeInfo.append(" ").append(sub).append(" varrefs").append("\n");
      }
      if(this.statementAliveCombinations != null) {
         sizeInfo.append("SIZE statementAliveCombinations ").append(statementAliveCombinations.size()).append(" statements ");
         int subVarRef = 0;
         int subAlias = 0;
         int subCallPath = 0;
         int subEffectiveVarRef = 0;
         for(AliveCombinationsCallPath aliveCombinations : statementAliveCombinations.values()) {
            subVarRef += aliveCombinations.aliveAtStmt.size();
            subVarRef += aliveCombinations.referencedInProcedure.size();
            if(aliveCombinations.callAliases != null)
               subAlias += aliveCombinations.callAliases.size();
            if(aliveCombinations.callPaths.callPaths != null)
               subCallPath += aliveCombinations.callPaths.callPaths.size();
            if(aliveCombinations.effectiveAliveAtStmt != null)
               for(Collection<VariableRef> varRefs : aliveCombinations.effectiveAliveAtStmt.values()) {
                  subEffectiveVarRef += varRefs.size();
               }
         }
         sizeInfo.append(" ").append(subVarRef).append(" varrefs ");
         sizeInfo.append(" ").append(subAlias).append(" aliases ");
         sizeInfo.append(" ").append(subCallPath).append(" callpaths ");
         sizeInfo.append(" ").append(subEffectiveVarRef).append(" eff-varrefs ");
         sizeInfo.append("\n");
      }
      return sizeInfo.toString();
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
    * The call-path is the path from the main()-procedure to the procedure in question.
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
       *
       * @return Tha call path
       */
      public List<CallGraph.CallBlock.Call> getPath() {
         return path;
      }

      /**
       * Alive variables on the call-path. Based on alive vars at each call in the path.
       *
       * @return The alive variables
       */
      public Collection<VariableRef> getAlive() {
         return alive;
      }

      /**
       * Alias variables from the entire call-path. Any variables alias-assigned as part of a call on the path (in parameter assignment or phi block).
       *
       * @return The aliases
       */
      public Pass2AliasElimination.Aliases getPathAliases() {
         return pathAliases;
      }

      /**
       * Alias variables for the innermost call. Variables alias-assigned as part of the innermost call on the path (in parameter assignment or phi block).
       *
       * @return The aliases
       */
      Pass2AliasElimination.Aliases getInnerAliases() {
         return innerAliases;
      }

      @Override
      public boolean equals(Object o) {
         if(this == o) return true;
         if(o == null || getClass() != o.getClass()) return false;
         CallPath callPath = (CallPath) o;
         return Objects.equals(path, callPath.path);
      }

      @Override
      public int hashCode() {
         return Objects.hash(path);
      }
   }

   /**
    * Combinations of variables effectively alive at a specific statement.
    * If the statement is inside a method the combinations are the live variables inside the method combined with each calling statements alive vars.
    * As each caller might also be inside a method there may be a large amount of combinations.
    */
   public static class AliveCombinationsCallPath implements AliveCombinations {

      /**
       * All call-paths to the procedure containing the statement.
       */
      private LiveRangeVariablesEffectiveCallPaths.CallPaths callPaths;
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

      /** Effective alive variables for each call path. */
      private Map<LiveRangeVariablesEffectiveCallPaths.CallPath, Collection<VariableRef>> effectiveAliveAtStmt;

      AliveCombinationsCallPath(LiveRangeVariablesEffectiveCallPaths.CallPaths callPaths, Collection<VariableRef> referencedInProcedure, Collection<VariableRef> aliveAtStmt, Pass2AliasElimination.Aliases callAliases) {
         this.callPaths = callPaths;
         this.referencedInProcedure = referencedInProcedure;
         this.aliveAtStmt = aliveAtStmt;
         this.callAliases = callAliases;
         // Initialize the effective alive at statement per call-path
         this.effectiveAliveAtStmt = new LinkedHashMap<>();
         for(LiveRangeVariablesEffectiveCallPaths.CallPath callPath : callPaths.getCallPaths()) {
            // Add alive at call
            LinkedHashSet<VariableRef> effectiveAlive = new LinkedHashSet<>();
            // Add alive through the call path
            effectiveAlive.addAll(callPath.getAlive());
            // Clear out any variables referenced in the method
            effectiveAlive.removeAll(referencedInProcedure);
            // Add alive at statement
            effectiveAlive.addAll(aliveAtStmt);
            // Store the effective alive vars
            effectiveAliveAtStmt.put(callPath, effectiveAlive);
         }
      }

      public LiveRangeVariablesEffectiveCallPaths.CallPaths getCallPaths() {
         return callPaths;
      }

      /**
       * Get all variables effective alive at the statement for a specific call path.
       *
       * @param callPath The call path (returned from getCallPaths)
       * @return All variables effectively alive at the statement on the call-path
       */
      Collection<VariableRef> getEffectiveAliveAtStmt(LiveRangeVariablesEffectiveCallPaths.CallPath callPath) {
         return effectiveAliveAtStmt.get(callPath);
      }

      Pass2AliasElimination.Aliases getEffectiveAliasesAtStmt(LiveRangeVariablesEffectiveCallPaths.CallPath callPath) {
         if(callAliases == null) {
            return callPath.getPathAliases();
         } else {
            Pass2AliasElimination.Aliases aliases = new Pass2AliasElimination.Aliases();
            aliases.addAll(callPath.getPathAliases());
            aliases.addAll(callAliases);
            return aliases;
         }
      }

      /**
       * Get all effective alive combinations for a specific statement.
       *
       * @return All effective alive combinations
       */
      public Collection<LiveRangeVariablesEffective.AliveCombination> getAll() {
         final ArrayList<LiveRangeVariablesEffective.AliveCombination> aliveCombinations = new ArrayList<>();
         for(LiveRangeVariablesEffectiveCallPaths.CallPath callPath : callPaths.getCallPaths()) {
            aliveCombinations.add(new AliveCombinationCallPath(callPath, getEffectiveAliveAtStmt(callPath), getEffectiveAliasesAtStmt(callPath)));
         }
         return aliveCombinations;
      }
   }

   /** An alive combination at a specific statement */
   public static class AliveCombinationCallPath implements LiveRangeVariablesEffective.AliveCombination {

      private LiveRangeVariablesEffectiveCallPaths.CallPath callPath;
      private Collection<VariableRef> effectiveAliveAtStmt;
      private Pass2AliasElimination.Aliases effectiveAliasesAtStmt;

      AliveCombinationCallPath(LiveRangeVariablesEffectiveCallPaths.CallPath callPath, Collection<VariableRef> effectiveAliveAtStmt, Pass2AliasElimination.Aliases effectiveAliasesAtStmt) {
         this.callPath = callPath;
         this.effectiveAliveAtStmt = effectiveAliveAtStmt;
         this.effectiveAliasesAtStmt = effectiveAliasesAtStmt;
      }

      public LiveRangeVariablesEffectiveCallPaths.CallPath getCallPath() {
         return callPath;
      }

      public Collection<VariableRef> getEffectiveAliveAtStmt() {
         return effectiveAliveAtStmt;
      }

      public Pass2AliasElimination.Aliases getEffectiveAliasesAtStmt() {
         return effectiveAliasesAtStmt;
      }

      @Override
      public String toString(Program program) {
         StringBuilder out = new StringBuilder();
         out.append(getCallPathString(callPath.getPath()));
         out.append(getAliveString(getEffectiveAliveAtStmt()));
         out.append(" ");
         out.append(getEffectiveAliasesAtStmt().toString(program));
         return out.toString();
      }

      private String getCallPathString(List<CallGraph.CallBlock.Call> path) {
         StringBuilder out = new StringBuilder();
         boolean first = true;
         for(CallGraph.CallBlock.Call call : path) {
            if(!first) {
               out.append("::");
            }
            first = false;
            out.append(call.toString());
         }
         return out.toString();
      }

      private String getAliveString(Collection<VariableRef> alive) {
         StringBuilder str = new StringBuilder();
         str.append(" [ ");
         for(VariableRef variableRef : alive) {
            str.append(variableRef.getFullName());
            str.append(" ");
         }
         str.append("]");
         return str.toString();
      }
   }


}
