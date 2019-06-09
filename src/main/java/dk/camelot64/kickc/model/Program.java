package dk.camelot64.kickc.model;

import dk.camelot64.kickc.CompileLog;
import dk.camelot64.kickc.asm.AsmProgram;
import dk.camelot64.kickc.model.statements.StatementInfos;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.values.LabelRef;
import dk.camelot64.kickc.model.values.VariableRef;
import dk.camelot64.kickc.passes.Pass1UnwindStructValues;

import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Map;

/** A KickC Intermediate Compiler Language (ICL) Program */
public class Program {

   /** The name of the file being compiled. */
   private String fileName;
   /** Paths used for importing files. */
   private List<String> importPaths;
   /** Imported files. */
   private List<String> imported;
   /** The initial statement sequence generated by the parser. */
   private StatementSequence statementSequence;
   /** The main scope. */
   private ProgramScope scope;
   /** The control flow graph. */
   private ControlFlowGraph graph;
   /** The 6502 ASM program. */
   private AsmProgram asm;
   /** Resource files that should be copied to the output folder to be compiled with the generated ASM. */
   private List<Path> asmResourceFiles;
   /** Comments for the (main) file. */
   private List<Comment> fileComments;

   /** The log containing information about the compilation process. */
   private CompileLog log;

   /** Variables modified inside procedures. */
   private ProcedureModifiedVars procedureModifiedVars;
   /** Information about calls. */
   private CallGraph callGraph;
   /** Information about dominators of all blocks */
   private DominatorsGraph dominators;
   /** Information about loops. */
   private NaturalLoopSet loopSet;

   /** Which block is each statement a part of. */
   private StatementInfos statementInfos;
   /** Cached information about symbols. Contains a symbol table cache for fast access. */
   private SymbolInfos symbolInfos;
   /** The variables referenced by blocks/statements. */
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
   /** Constants identified during pass 1. */
   private Collection<VariableRef> earlyIdentifiedConstants;
   /** Reserved ZP addresses that the compiler cannot use. */
   private List<Number> reservedZps;
   /** Absolute start address of the code. Null to start ad 0x080d. */
   private Number programPc;
   /** Cached phi transitions into each block. */
   private Map<LabelRef, PhiTransitions> phiTransitions;
   /** Struct values unwound to individual variables. */
   private Pass1UnwindStructValues.StructUnwinding structUnwinding;

   public Program() {
      this.scope = new ProgramScope();
      this.log = new CompileLog();
      this.importPaths = new ArrayList<>();
      this.imported = new ArrayList<>();
      this.asmResourceFiles = new ArrayList<>();
      this.reservedZps = new ArrayList<>();
   }

   public Pass1UnwindStructValues.StructUnwinding getStructUnwinding() {
      return structUnwinding;
   }

   public void setStructUnwinding(Pass1UnwindStructValues.StructUnwinding structUnwinding) {
      this.structUnwinding = structUnwinding;
   }

   public Map<LabelRef, PhiTransitions> getPhiTransitions() {
      return phiTransitions;
   }

   public void setPhiTransitions(Map<LabelRef, PhiTransitions> phiTransitions) {
      this.phiTransitions = phiTransitions;
   }

   public List<Comment> getFileComments() {
      return fileComments;
   }

   public void setFileComments(List<Comment> fileComments) {
      this.fileComments = fileComments;
   }

   public List<String> getImportPaths() {
      return importPaths;
   }

   public List<String> getImported() {
      return imported;
   }

   public List<Path> getAsmResourceFiles() {
      return asmResourceFiles;
   }

   public void addAsmResourceFile(Path asmResourceFile) {
      asmResourceFiles.add(asmResourceFile);
   }

   public StatementSequence getStatementSequence() {
      return statementSequence;
   }

   public void setStatementSequence(StatementSequence statementSequence) {
      this.statementSequence = statementSequence;
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

   public ProcedureModifiedVars getProcedureModifiedVars() {
      return procedureModifiedVars;
   }

   public void setProcedureModifiedVars(ProcedureModifiedVars procedureModifiedVars) {
      this.procedureModifiedVars = procedureModifiedVars;
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

   public DominatorsGraph getDominators() {
      return dominators;
   }

   public void setDominators(DominatorsGraph dominators) {
      this.dominators = dominators;
   }

   public NaturalLoopSet getLoopSet() {
      return loopSet;
   }

   public void setLoopSet(NaturalLoopSet loopSet) {
      this.loopSet = loopSet;
   }

   public VariableReferenceInfos getVariableReferenceInfos() {
      return variableReferenceInfos;
   }

   public void setVariableReferenceInfos(VariableReferenceInfos variableReferenceInfos) {
      this.variableReferenceInfos = variableReferenceInfos;
   }

   public StatementInfos getStatementInfos() {
      return statementInfos;
   }

   public void setStatementInfos(StatementInfos statementInfos) {
      this.statementInfos = statementInfos;
   }

   public SymbolInfos getSymbolInfos() {
      return symbolInfos;
   }

   public void setSymbolInfos(SymbolInfos symbolInfos) {
      this.symbolInfos = symbolInfos;
   }

   public LiveRangeVariables getLiveRangeVariables() {
      return liveRangeVariables;
   }

   public void setLiveRangeVariables(LiveRangeVariables liveRangeVariables) {
      this.liveRangeVariables = liveRangeVariables;
   }

   public LiveRangeVariablesEffective getLiveRangeVariablesEffective() {
      return liveRangeVariablesEffective;
   }

   public void setLiveRangeVariablesEffective(LiveRangeVariablesEffective liveRangeVariablesEffective) {
      this.liveRangeVariablesEffective = liveRangeVariablesEffective;
   }

   public LiveRangeEquivalenceClassSet getLiveRangeEquivalenceClassSet() {
      return liveRangeEquivalenceClassSet;
   }

   public void setLiveRangeEquivalenceClassSet(LiveRangeEquivalenceClassSet liveRangeEquivalenceClassSet) {
      this.liveRangeEquivalenceClassSet = liveRangeEquivalenceClassSet;
   }

   public VariableRegisterWeights getVariableRegisterWeights() {
      return variableRegisterWeights;
   }

   public void setVariableRegisterWeights(VariableRegisterWeights variableRegisterWeights) {
      this.variableRegisterWeights = variableRegisterWeights;
   }

   public RegisterPotentials getRegisterPotentials() {
      return registerPotentials;
   }

   public void setRegisterPotentials(RegisterPotentials registerPotentials) {
      this.registerPotentials = registerPotentials;
   }

   public RegisterUpliftProgram getRegisterUpliftProgram() {
      return registerUpliftProgram;
   }

   public void setRegisterUpliftProgram(RegisterUpliftProgram registerUpliftProgram) {
      this.registerUpliftProgram = registerUpliftProgram;
   }

   public Collection<VariableRef> getEarlyIdentifiedConstants() {
      return earlyIdentifiedConstants;
   }

   public void setEarlyIdentifiedConstants(Collection<VariableRef> earlyIdentifiedConstants) {
      this.earlyIdentifiedConstants = earlyIdentifiedConstants;
   }

   public CompileLog getLog() {
      return log;
   }

   public void setLog(CompileLog log) {
      this.log = log;
   }


   @Override
   public boolean equals(Object o) {
      if(this == o) return true;
      if(o == null || getClass() != o.getClass()) return false;

      Program program = (Program) o;

      if(scope != null ? !scope.equals(program.scope) : program.scope != null) return false;
      if(graph != null ? !graph.equals(program.graph) : program.graph != null) return false;
      return asm != null ? asm.equals(program.asm) : program.asm == null;
   }

   @Override
   public int hashCode() {
      int result = scope != null ? scope.hashCode() : 0;
      result = 31 * result + (graph != null ? graph.hashCode() : 0);
      result = 31 * result + (asm != null ? asm.hashCode() : 0);
      return result;
   }

   public void setFileName(String fileName) {
      this.fileName = fileName;
   }

   public String getFileName() {
      return fileName;
   }

   /**
    * Adds a bunch of reserved zero-page addresses that the compiler is not allowed to use.
    * @param reservedZp addresses to reserve
    */
   public void addReservedZps(List<Number> reservedZp) {
      for(Number zp : reservedZp) {
         if(!this.reservedZps.contains(zp)) {
            this.reservedZps.add(zp);
         }
      }
   }

   public List<Number> getReservedZps() {
      return reservedZps;
   }

   /**
    * Set the absolute position of the program code
    * @param programPc The address
    */
   public void setProgramPc(Number programPc) {
      this.programPc = programPc;
   }

   public Number getProgramPc() {
      return programPc;
   }
}
