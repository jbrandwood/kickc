package dk.camelot64.kickc.model;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;
import dk.camelot64.kickc.CompileLog;
import dk.camelot64.kickc.asm.AsmProgram;

/** A KickC Intermediate Compiler Language (ICL) Program */
public class Program {

   /** The main scope. */
   private ProgramScope scope;
   /** The control flow graph. */
   private ControlFlowGraph graph;
   /** The 6502 ASM program. */
   private AsmProgram asm;

   /** The log containing information about the compilation process. */
   private CompileLog log;

   /** Variables modified inside procedures. */
   private ProcedureModifiedVars procedureModifiedVars;
   /** Information about calls. */
   private CallGraph callGraph;
   /** Information about dominators of all blocks*/
   private DominatorsGraph dominators;
   /** Information about loops. */
   private NaturalLoopSet loopSet;

   /** Which block is each statement a part of. */
   private StatementBlocks statementBlocks;
   /** The variables freferenced by blocks/statements. */
   private VariableReferenceInfos variableReferenceInfos;
   /** The live ranges of all variables. */
   private LiveRangeVariables liveRangeVariables;
   /** Live range equivalence classes containing variables that do not have overlapping live ranges. */
   private LiveRangeEquivalenceClassSet liveRangeEquivalenceClassSet;
   /** The effective live ranges of all variables. */
   private LiveRangeVariablesEffective liveRangeVariablesEffective;
   /** The register weight of all variables describing how much the variable would theoretically gain from being in a register */
   private VariableRegisterWeights variableRegisterWeights;
   /** Registers potentially usable as allocation for each live range equivalence class. */
   private RegisterPotentials registerPotentials;
   /** Separation of live range equivalence classes into scopes - used for register uplift */
   private RegisterUpliftProgram registerUpliftProgram;

   @JsonCreator
   public Program(
         @JsonProperty("scope") ProgramScope scope,
         @JsonProperty("graph") ControlFlowGraph graph,
         @JsonProperty("asm") AsmProgram asm) {
      this.scope = scope;
      this.graph = graph;
      this.asm = asm;
   }

   public Program(ProgramScope programScope, CompileLog log) {
      this.scope = programScope;
      this.log = log;
   }

   public ProgramScope getScope() {
      return scope;
   }

   public void setScope(ProgramScope scope) {
      this.scope = scope;
   }

   public ControlFlowGraph getGraph() {
      return graph;
   }

   public void setGraph(ControlFlowGraph graph) {
      this.graph = graph;
   }

   public void setProcedureModifiedVars(ProcedureModifiedVars procedureModifiedVars) {
      this.procedureModifiedVars = procedureModifiedVars;
   }

   public ProcedureModifiedVars getProcedureModifiedVars() {
      return procedureModifiedVars;
   }

   public AsmProgram getAsm() {
      return asm;
   }

   public void setAsm(AsmProgram asm) {
      this.asm = asm;
   }

   public CallGraph getCallGraph() {
      return callGraph;
   }

   public void setCallGraph(CallGraph callGraph) {
      this.callGraph = callGraph;
   }

   public void setDominators(DominatorsGraph dominators) {
      this.dominators = dominators;
   }

   public DominatorsGraph getDominators() {
      return dominators;
   }

   public void setLoops(NaturalLoopSet loopSet) {
      this.loopSet = loopSet;
   }

   public NaturalLoopSet getLoopSet() {
      return loopSet;
   }

   public VariableReferenceInfos getVariableReferenceInfos() {
      return variableReferenceInfos;
   }

   public void setVariableReferenceInfos(VariableReferenceInfos variableReferenceInfos) {
      this.variableReferenceInfos = variableReferenceInfos;
   }

   public StatementBlocks getStatementBlocks() {
      return statementBlocks;
   }

   public void setStatementBlocks(StatementBlocks statementBlocks) {
      this.statementBlocks = statementBlocks;
   }

   public void setLiveRangeVariables(LiveRangeVariables liveRangeVariables) {
      this.liveRangeVariables = liveRangeVariables;
   }

   public LiveRangeVariables getLiveRangeVariables() {
      return liveRangeVariables;
   }

   public LiveRangeVariablesEffective getLiveRangeVariablesEffective() {
      return liveRangeVariablesEffective;
   }

   public void setLiveRangeVariablesEffective(LiveRangeVariablesEffective liveRangeVariablesEffective) {
      this.liveRangeVariablesEffective = liveRangeVariablesEffective;
   }

   public void setLiveRangeEquivalenceClassSet(LiveRangeEquivalenceClassSet liveRangeEquivalenceClassSet) {
      this.liveRangeEquivalenceClassSet = liveRangeEquivalenceClassSet;
   }

   public LiveRangeEquivalenceClassSet getLiveRangeEquivalenceClassSet() {
      return liveRangeEquivalenceClassSet;
   }

   public void setVariableRegisterWeights(VariableRegisterWeights variableRegisterWeights) {
      this.variableRegisterWeights = variableRegisterWeights;
   }

   public VariableRegisterWeights getVariableRegisterWeights() {
      return variableRegisterWeights;
   }

   public void setRegisterPotentials(RegisterPotentials registerPotentials) {
      this.registerPotentials = registerPotentials;
   }

   public RegisterPotentials getRegisterPotentials() {
      return registerPotentials;
   }

   public void setRegisterUpliftProgram(RegisterUpliftProgram registerUpliftProgram) {
      this.registerUpliftProgram = registerUpliftProgram;
   }

   public RegisterUpliftProgram getRegisterUpliftProgram() {
      return registerUpliftProgram;
   }

   public CompileLog getLog() {
      return log;
   }

   public void setLog(CompileLog log) {
      this.log = log;
   }


   @Override
   public boolean equals(Object o) {
      if (this == o) return true;
      if (o == null || getClass() != o.getClass()) return false;

      Program program = (Program) o;

      if (scope != null ? !scope.equals(program.scope) : program.scope != null) return false;
      if (graph != null ? !graph.equals(program.graph) : program.graph != null) return false;
      return asm != null ? asm.equals(program.asm) : program.asm == null;
   }

   @Override
   public int hashCode() {
      int result = scope != null ? scope.hashCode() : 0;
      result = 31 * result + (graph != null ? graph.hashCode() : 0);
      result = 31 * result + (asm != null ? asm.hashCode() : 0);
      return result;
   }

}
