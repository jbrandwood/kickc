package dk.camelot64.kickc.model;

import dk.camelot64.kickc.CompileLog;
import dk.camelot64.kickc.OutputFileManager;
import dk.camelot64.kickc.asm.AsmProgram;
import dk.camelot64.kickc.fragment.synthesis.AsmFragmentTemplateMasterSynthesizer;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.values.LabelRef;
import dk.camelot64.kickc.model.values.ProcedureRef;
import dk.camelot64.kickc.passes.calcs.*;

import java.nio.file.Path;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/** A KickC Intermediate Compiler Language (ICL) Program */
public class Program {

   /** The log containing information about the compilation process. */
   private CompileLog log;

   /** The manager responsible for creating output files. PASS 0-5 (STATIC) */
   private OutputFileManager outputFileManager;

   /** Paths used for including files. PASS 0 (STATIC) */
   private List<String> includePaths;
   /** Paths used for library files. PASS 0 (STATIC) */
   private List<String> libraryPaths;
   /** Paths used for target files. PASS 0 (STATIC) */
   private List<String> targetPlatformPaths;
   /** All loaded H/C-files. PASS 0 (STATIC) */
   private List<String> loadedFiles;

   /** The target platform that the program is being build for. PASS 0-5 (STATIC) */
   private TargetPlatform targetPlatform;

   /** Base folder for finding ASM fragment files. (STATIC) */
   private Path asmFragmentBaseFolder;
   /** The ASM fragment synthesizer responsible for loading/synthesizing ASM fragments. Depends on the target CPU. (STATIC) */
   private AsmFragmentTemplateMasterSynthesizer asmFragmentMasterSynthesizer;

   /** Missing fragments produce a warning instead of an error (STATIC) */
   private boolean warnFragmentMissing = false;
   /** Array syntax used on types (eg. char[8] x; ) produce a warning instead of an error (STATIC) */
   private boolean warnArrayType = false;
   /** Enable live ranges per call path optimization, which limits memory usage and code, but takes a lot of compile time. */
   private boolean enableLiveRangeCallPath = true;

   /** Reserved ZP addresses that the compiler cannot use. PASS 0-5 (STATIC) */
   private List<Integer> reservedZps;
   /** Resource files that should be copied to the output folder to be compiled with the generated ASM. PASS 0-5 (STATIC) */
   private final List<Path> asmResourceFiles;
   /** Comments for the (main) file. PASS 0-4 (STATIC) */
   private List<Comment> mainFileComments;

   /** The main scope. PASS 0-5 (DYNAMIC) */
   private ProgramScope scope;
   /** The control flow graph. PASS 1-5 (DYNAMIC) */
   private ControlFlowGraph graph;
   /** The procedure that starts the execution of the program. (Default: _start() which calls _init() and main() ) */
   private ProcedureRef startProcedure;

   /** Struct values unwound to individual variables. PASS 1 (STATIC) */
   private StructVariableMemberUnwinding structVariableMemberUnwinding;

   /** Cached information about calls. PASS 1-4 (CACHED ON-DEMAND) */
   private CallGraph callGraph;

   /** The procedures being compiled. */
   private final Map<ProcedureRef, ProcedureCompilation> procedureCompilations;

   /** Variables modified inside procedures. PASS 1 (STATIC) */
   private ProcedureModifiedVars procedureModifiedVars;

   /** Registers potentially usable as allocation for each live range equivalence class. PASS 4 (DYNAMIC) */
   private RegisterPotentials registerPotentials;
   /** Live range equivalence classes containing variables that do not have overlapping live ranges. PASS 3-5 (DYNAMIC) */
   private LiveRangeEquivalenceClassSet liveRangeEquivalenceClassSet;
   /** The 6502 ASM program. PASS 4-5 (DYNAMIC) */
   private AsmProgram asm;

   /** A saved program snapshot that can be rolled back. Used to store the (DYNAMIC) state of the program while trying out a potential optimization. PASS 2 (DYNAMIC) */
   private ProgramSnapshot snapshot;

   /** Cached information about the variables referenced by blocks/statements. PASS 1-4 (CACHED ON-DEMAND) */
   private VariableReferenceInfos variableReferenceInfos;
   /** Cached information about the closure of all block successors. */
   private ControlFlowBlockSuccessorClosure blockSuccessorClosure;
   /** Information about dominators of all blocks. PASS 2U-4 (CACHED ON-DEMAND) */
   private DominatorsGraph dominators;
   /** Cached information about symbols. Contains a symbol table cache for fast access. PASS 3-4 (CACHED ON-DEMAND) */
   private SymbolInfos symbolInfos;
   /** Cached phi transitions into each block. PASS 4 (CACHED ON-DEMAND) */
   private Map<LabelRef, PhiTransitions> phiTransitions;
   /** The live ranges of all variables. PASS 3-4 (CACHED ON-DEMAND) */
   private LiveRangeVariables liveRangeVariables;
   /** The effective live ranges of all variables. PASS 3-4 (CACHED ON-DEMAND) */
   private LiveRangeVariablesEffective liveRangeVariablesEffective;
   /** Separation of live range equivalence classes into scopes - used for register uplift. PASS 4 (CACHED ON-DEMAND) */
   private RegisterUpliftProgram registerUpliftProgram;
   /** Cached information about which block is each statement a part of. PASS 2U-5 (CACHED ON-DEMAND) */
   private StatementInfos statementInfos;
   /** Information about loops. PASS 2U-5 (CACHED ON-DEMAND) */
   private NaturalLoopSet loopSet;
   /** The register weight of all variables describing how much the variable would theoretically gain from being in a register. PASS 3-5 (CACHED ON-DEMAND) */
   private VariableRegisterWeights variableRegisterWeights;

   public Program() {
      this.outputFileManager = new OutputFileManager();
      this.scope = new ProgramScope();
      this.log = new CompileLog();
      this.includePaths = new ArrayList<>();
      this.libraryPaths = new ArrayList<>();
      this.targetPlatformPaths = new ArrayList<>();
      this.loadedFiles = new ArrayList<>();
      this.asmResourceFiles = new ArrayList<>();
      this.reservedZps = new ArrayList<>();
      this.procedureCompilations = new LinkedHashMap<>();
   }

   /**
    * Clears all data that is only used in PASS 1
    */
   public void endPass1() {
      this.includePaths = null;
      this.libraryPaths = null;
      this.targetPlatformPaths = null;
      this.loadedFiles = null;
      this.procedureModifiedVars = null;
      this.structVariableMemberUnwinding = null;
   }

   /**
    * Clears all data that is only used in PASS 2-4
    */
   public void endPass4() {
      this.snapshot = null;
      this.mainFileComments = null;
      this.callGraph = null;
      this.variableReferenceInfos = null;
      this.dominators = null;
      this.symbolInfos = null;
      this.phiTransitions = null;
      this.liveRangeVariables = null;
      this.liveRangeVariablesEffective = null;
      this.registerPotentials = null;
      this.registerUpliftProgram = null;
   }

   /** Save a snapshot of the dynamic parts of the program. */
   public void snapshotCreate() {
      if(this.snapshot != null)
         throw new InternalError("Snapshot already saved!");
      if(this.liveRangeEquivalenceClassSet != null)
         throw new InternalError("Compiler Program Snapshot does not support liveRangeEquivalenceClassSet!");
      this.snapshot = new ProgramSnapshot(scope, graph);
   }

   /** Restore the snapshot of the dynamic parts of the program. Clear all cached data and the snapshot. */
   public void snapshotRestore() {
      this.scope = snapshot.getScope();
      this.graph = snapshot.getGraph();
      this.snapshot = null;
      this.callGraph = null;
      this.variableReferenceInfos = null;
      this.dominators = null;
      this.loopSet = null;
      this.statementInfos = null;
      this.symbolInfos = null;
      this.phiTransitions = null;
      this.liveRangeVariables = null;
      this.liveRangeVariablesEffective = null;
      this.variableRegisterWeights = null;
      this.registerPotentials = null;
      this.registerUpliftProgram = null;
      this.asm = null;
   }

   public OutputFileManager getOutputFileManager() {
      return outputFileManager;
   }

   public void setEnableLiveRangeCallPath(boolean enableLiveRangeCallPath) {
      this.enableLiveRangeCallPath = enableLiveRangeCallPath;
   }

   public boolean isWarnFragmentMissing() {
      return warnFragmentMissing;
   }

   public void setWarnFragmentMissing(boolean warnFragmentMissing) {
      this.warnFragmentMissing = warnFragmentMissing;
   }

   public boolean isWarnArrayType() {
      return warnArrayType;
   }

   public void setWarnArrayType(boolean errorArrayKickC) {
      this.warnArrayType = errorArrayKickC;
   }

   public Path getAsmFragmentBaseFolder() {
      return asmFragmentBaseFolder;
   }

   public void setAsmFragmentBaseFolder(Path asmFragmentBaseFolder) {
      this.asmFragmentBaseFolder = asmFragmentBaseFolder;
   }

   public AsmFragmentTemplateMasterSynthesizer getAsmFragmentMasterSynthesizer() {
      return asmFragmentMasterSynthesizer;
   }

   public void initAsmFragmentMasterSynthesizer(Path asmFragmentCacheFolder) {
      this.asmFragmentMasterSynthesizer = new AsmFragmentTemplateMasterSynthesizer(asmFragmentCacheFolder, asmFragmentBaseFolder, getLog());
   }

   public TargetPlatform getTargetPlatform() {
      return targetPlatform;
   }

   public void setTargetPlatform(TargetPlatform targetPlatform) {
      this.targetPlatform = targetPlatform;
   }

   public TargetCpu getTargetCpu() {
      return getTargetPlatform().getCpu();
   }

   public StructVariableMemberUnwinding getStructVariableMemberUnwinding() {
      return structVariableMemberUnwinding;
   }

   public void setStructVariableMemberUnwinding(StructVariableMemberUnwinding structVariableMemberUnwinding) {
      this.structVariableMemberUnwinding = structVariableMemberUnwinding;
   }

   public List<Comment> getMainFileComments() {
      return mainFileComments;
   }

   public void setMainFileComments(List<Comment> mainFileComments) {
      this.mainFileComments = mainFileComments;
   }

   public List<String> getIncludePaths() {
      return includePaths;
   }

   public List<String> getLibraryPaths() {
      return libraryPaths;
   }

   public List<String> getTargetPlatformPaths() {
      return targetPlatformPaths;
   }

   public List<String> getLoadedFiles() {
      return loadedFiles;
   }

   public List<Path> getAsmResourceFiles() {
      return asmResourceFiles;
   }

   public void addAsmResourceFile(Path asmResourceFile) {
      asmResourceFiles.add(asmResourceFile);
   }

   public ProcedureCompilation createProcedureCompilation(ProcedureRef procedureRef) {
      if(procedureCompilations.get(procedureRef)!=null)
         throw new CompileError("Error! Procedure already defined "+procedureRef.getFullName());
      final ProcedureCompilation procedureCompilation = new ProcedureCompilation(procedureRef);
      procedureCompilations.put(procedureRef, procedureCompilation);
      return procedureCompilation;
   }

   public ProcedureCompilation getProcedureCompilation(ProcedureRef procedureRef) {
      return procedureCompilations.get(procedureRef);
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

   public ProcedureRef getStartProcedure() {
      return startProcedure;
   }

   public void setStartProcedure(ProcedureRef startProcedure) {
      this.startProcedure = startProcedure;
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

   /**
    * Get the call-graph for the program. Calculates the call-graph if it has not already been calculated.
    *
    * @return The call-graph
    */
   public CallGraph getCallGraph() {
      if(callGraph == null)
         this.callGraph = new PassNCalcCallGraph(this).calculate();
      return callGraph;
   }

   /**
    * Clears the call-graph ensuring it will be re-calculated if used.
    */
   public void clearCallGraph() {
      this.callGraph = null;
   }

   public VariableReferenceInfos getVariableReferenceInfos() {
      if(variableReferenceInfos == null)
         this.variableReferenceInfos = new PassNCalcVariableReferenceInfos(this).calculate();
      return variableReferenceInfos;
   }

   public void clearVariableReferenceInfos() {
      this.variableReferenceInfos = null;
   }

   public ControlFlowBlockSuccessorClosure getControlFlowBlockSuccessorClosure() {
      if(blockSuccessorClosure == null)
         this.blockSuccessorClosure = new PassNCalcBlockSuccessorClosure(this).calculate();
      return blockSuccessorClosure;
   }

   public void clearControlFlowBlockSuccessorClosure() {
      this.blockSuccessorClosure = null;
   }

   public DominatorsGraph getDominators() {
      if(dominators == null)
         this.dominators = new PassNCalcDominators(this).calculate();
      return dominators;
   }

   public void clearDominators() {
      this.dominators = null;
   }

   public Map<LabelRef, PhiTransitions> getPhiTransitions() {
      if(phiTransitions == null)
         this.phiTransitions = new PassNCalcPhiTransitions(this).calculate();
      return phiTransitions;
   }

   public void clearPhiTransitions() {
      this.phiTransitions = null;
   }

   public LiveRangeVariables getLiveRangeVariables() {
      if(liveRangeVariables == null)
         this.liveRangeVariables = new PassNCalcLiveRangeVariables(this).calculate();
      return liveRangeVariables;
   }

   public void setLiveRangeVariables(LiveRangeVariables liveRangeVariables) {
      this.liveRangeVariables = liveRangeVariables;
   }

   public boolean hasLiveRangeVariables() {
      return this.liveRangeVariables != null;
   }

   public void clearLiveRangeVariables() {
      this.liveRangeVariables = null;
   }

   public StatementInfos getStatementInfos() {
      if(statementInfos == null)
         this.statementInfos = new PassNCalcStatementInfos(this).calculate();
      return statementInfos;
   }

   public void clearStatementInfos() {
      this.statementInfos = null;
   }

   /**
    * Clear index numbers for all statements in the control flow graph.
    */
   public void clearStatementIndices() {
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            statement.setIndex(null);
         }
      }
   }

   public SymbolInfos getSymbolInfos() {
      if(symbolInfos == null)
         this.symbolInfos = new PassNCalcSymbolInfos(this).calculate();
      return symbolInfos;
   }

   public boolean hasLiveRangeVariablesEffective() {
      return liveRangeVariablesEffective != null;
   }

   public LiveRangeVariablesEffective getLiveRangeVariablesEffective() {
      if(liveRangeVariablesEffective == null) {
         if(enableLiveRangeCallPath) {
            this.liveRangeVariablesEffective = new PassNCalcLiveRangesEffectiveCallPaths(this).calculate();
         } else {
            this.liveRangeVariablesEffective = new PassNCalcLiveRangesEffectiveSimple(this).calculate();
         }
      }
      return liveRangeVariablesEffective;
   }

   public void clearLiveRangeVariablesEffective() {
      this.liveRangeVariablesEffective = null;
   }

   public RegisterUpliftProgram getRegisterUpliftProgram() {
      if(registerUpliftProgram == null)
         this.registerUpliftProgram = new PassNCalcRegisterUpliftProgram(this).calculate();
      return registerUpliftProgram;
   }

   public NaturalLoopSet getLoopSet() {
      if(loopSet == null)
         this.loopSet = new PassNCalcLoopSet(this).calculate();
      return loopSet;
   }

   public void clearLoopSet() {
      this.loopSet = null;
   }

   public VariableRegisterWeights getVariableRegisterWeights() {
      if(variableRegisterWeights == null)
         this.variableRegisterWeights = new PassNCalcVariableRegisterWeight(this).calculate();
      return variableRegisterWeights;
   }

   public VariableRegisterWeights getOrNullVariableRegisterWeights() {
      return variableRegisterWeights;
   }

   public LiveRangeEquivalenceClassSet getLiveRangeEquivalenceClassSet() {
      return liveRangeEquivalenceClassSet;
   }

   public void setLiveRangeEquivalenceClassSet(LiveRangeEquivalenceClassSet liveRangeEquivalenceClassSet) {
      this.liveRangeEquivalenceClassSet = liveRangeEquivalenceClassSet;
   }

   public RegisterPotentials getRegisterPotentials() {
      return registerPotentials;
   }

   public void setRegisterPotentials(RegisterPotentials registerPotentials) {
      this.registerPotentials = registerPotentials;
   }




   /**
    * Adds a bunch of reserved zero-page addresses that the compiler is not allowed to use.
    *
    * @param reservedZp addresses to reserve
    */
   public void addReservedZps(List<Integer> reservedZp) {
      for(Integer zp : reservedZp) {
         if(!this.reservedZps.contains(zp)) {
            this.reservedZps.add(zp);
         }
      }
   }

   public List<Integer> getReservedZps() {
      return reservedZps;
   }

   public void setReservedZps(List<Integer> reservedZps) {
      this.reservedZps = reservedZps;
   }

   public CompileLog getLog() {
      return log;
   }

   public void setLog(CompileLog log) {
      this.log = log;
   }

   /**
    * Get information about the size of the program
    *
    * @return Size information
    */
   public String getSizeInfo() {
      StringBuilder sizeInfo = new StringBuilder();
      sizeInfo.append(getScope().getSizeInfo());
      sizeInfo.append(getGraph().getSizeInfo());
      if(variableReferenceInfos != null)
         sizeInfo.append(variableReferenceInfos.getSizeInfo());
      if(getLiveRangeEquivalenceClassSet() != null)
         sizeInfo.append(getLiveRangeEquivalenceClassSet().getSizeInfo());
      if(liveRangeVariablesEffective != null)
         sizeInfo.append(liveRangeVariablesEffective.getSizeInfo());
      if(getAsm() != null)
         sizeInfo.append(getAsm().getSizeInfo());
      return sizeInfo.toString();
   }

}
