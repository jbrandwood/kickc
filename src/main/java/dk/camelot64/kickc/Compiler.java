package dk.camelot64.kickc;

import dk.camelot64.kickc.asm.AsmProgram;
import dk.camelot64.kickc.fragment.AsmFragmentTemplateSynthesizer;
import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.statements.StatementCall;
import dk.camelot64.kickc.model.statements.StatementSource;
import dk.camelot64.kickc.model.values.SymbolRef;
import dk.camelot64.kickc.parser.CParser;
import dk.camelot64.kickc.parser.KickCParser;
import dk.camelot64.kickc.passes.*;
import org.antlr.v4.runtime.RuleContext;

import java.io.File;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

/**
 * Perform KickC compilation and optimizations
 */
public class Compiler {

   private Program program;

   /** The number of combinations to test when uplifting variables into registers. */
   private int upliftCombinations = 100;

   /** Enable the zero-page coalesce pass. It takes a lot of time, but limits the zero page usage significantly. */
   private boolean enableZeroPageCoalasce = false;

   /** Disable the entire register uplift. This will create significantly less optimized ASM since registers are not utilized. */
   private boolean disableUplift = false;

   /** Enable loop head constant optimization. It identified whenever a while()/for() has a constant condition on the first iteration and rewrites it.
    * Currently the optimization is flaky and results in NPE's and wrong values in some programs. */
   private boolean enableLoopHeadConstant = false;

   /** File name of link script to use (from command line parameter). */
   private String linkScriptFileName;

   public Compiler() {
      this.program = new Program();
   }

   public void setDisableUplift(boolean disableUplift) {
      this.disableUplift = disableUplift;
   }

   public void setWarnFragmentMissing(boolean warnFragmentMissing) {
      program.setWarnFragmentMissing(warnFragmentMissing);
   }

   public void setLinkScriptFileName(String linkScript) {
      linkScriptFileName = linkScript;
   }

   public void setUpliftCombinations(int upliftCombinations) {
      this.upliftCombinations = upliftCombinations;
   }

   void enableZeroPageCoalesce() {
      this.enableZeroPageCoalasce = true;
   }

   void enableLoopHeadConstant() {
      this.enableLoopHeadConstant = true;
   }

   void disableLoopHeadConstant() {
      this.enableLoopHeadConstant = false;
   }

   void setTargetPlatform(TargetPlatform targetPlatform) {
      program.setTargetPlatform(targetPlatform);
   }

   public void setTargetCpu(TargetCpu targetCpu) {
      program.setTargetCpu(targetCpu);
   }

   public void setAsmFragmentBaseFolder(Path asmFragmentBaseFolder) {
      program.setAsmFragmentBaseFolder(asmFragmentBaseFolder);
   }

   public void setAsmFragmentCacheFolder(Path asmFragmentcacheDir) {
      program.setAsmFragmentCacheFolder(asmFragmentcacheDir);
   }

   public void initAsmFragmentSynthesizer() {
      program.initAsmFragmentSynthesizer();
   }

   public void initAsmFragmentSynthesizer(AsmFragmentTemplateSynthesizer synthesizer) {
      program.initAsmFragmentSynthesizer(synthesizer);
   }

   public AsmFragmentTemplateSynthesizer getAsmFragmentSynthesizer() {
      return program.getAsmFragmentSynthesizer();
   }

   public void setLog(CompileLog compileLog) {
      program.setLog(compileLog);
   }

   public CompileLog getLog() {
      return program.getLog();
   }

   public void addImportPath(String path) {
      program.getImportPaths().add(path);
   }

   public Program compile(String fileName) {
      if(fileName.endsWith(".kc")) {
         fileName = fileName.substring(0, fileName.length() - 3);
      }
      program.setFileName(fileName);

      try {
         Path currentPath = new File(".").toPath();
         if(this.linkScriptFileName != null) {
            SourceLoader.loadLinkScriptFile(linkScriptFileName, currentPath, program);
         }
         program.setStatementSequence(new StatementSequence());
         CParser cParser = new CParser(program);
         KickCParser.FileContext cFileContext = cParser.loadAndParseCFile(fileName, currentPath);
         Pass0GenerateStatementSequence pass0GenerateStatementSequence = new Pass0GenerateStatementSequence(cParser, cFileContext, program);
         pass0GenerateStatementSequence.generate();

         StatementSequence sequence = program.getStatementSequence();
         sequence.addStatement(new StatementCall(null, SymbolRef.MAIN_PROC_NAME, new ArrayList<>(), new StatementSource(RuleContext.EMPTY), Comment.NO_COMMENTS));
         program.setStatementSequence(sequence);

         pass1GenerateSSA();
         pass2Optimize();
         pass2UnrollLoops();
         pass2InlineConstants();

         //getLog().append("\nCONTROL FLOW GRAPH PASS 2");
         //getLog().append(program.getGraph().toString(program));

         //getLog().append("SYMBOL TABLE PASS 2");
         //getLog().append(program.getScope().toString(program, null));

         pass3Analysis();
         pass4RegisterAllocation();
         pass5GenerateAndOptimizeAsm();
         return program;
      } catch(Exception e) {
         throw e;
      }
   }

   private void pass1GenerateSSA() {
      if(getLog().isVerboseStatementSequence()) {
         getLog().append("\nSTATEMENTS");
         getLog().append(program.getStatementSequence().toString(program));
      }

      new Pass1GenerateControlFlowGraph(program).execute();
      new Pass1ResolveForwardReferences(program).execute();
      new PassNAssertStructMembers(program).execute();
      new Pass1UnwindBlockScopes(program).execute();
      new Pass1Procedures(program).execute();
      new PassNTypeInference(program).execute();
      new PassNTypeIdSimplification(program).execute();
      new Pass1StructTypeSizeFix(program).execute();
      new Pass1AssertReturn(program).execute();
      new Pass1AssertUsedVars(program).execute();
      new Pass1AssertNoModifyVars(program).execute();

      if(getLog().isVerbosePass1CreateSsa()) {
         getLog().append("SYMBOLS");
         getLog().append(program.getScope().toString(program, false));
      }

      new Pass1AddressOfVolatile(program).execute();
      new Pass1FixLValuesLoHi(program).execute();
      new Pass1AssertNoLValueIntermediate(program).execute();
      new PassNAddTypeConversionAssignment(program, false).execute();
      new Pass1AssertProcedureCallParameters(program).execute();

      if(getLog().isVerbosePass1CreateSsa()) {
         getLog().append("CONTROL FLOW GRAPH BEFORE SIZEOF FIX");
         getLog().append(program.getGraph().toString(program));
      }

      new Pass1PointerSizeofFix(program).execute(); // After this point in the code all pointer math is byte-based
      new PassNSizeOfSimplification(program).execute(); // Needed to eliminate sizeof() referencing pointer value variables

      new Pass1ConstantifyRValue(program).execute();
      new Pass1UnwindStructVariables(program).execute();
      new Pass1UnwindStructValues(program).execute();
      new PassNStructPointerRewriting(program).execute();

      new PassNAddBooleanCasts(program).execute();
      new PassNAddTypeConversionAssignment(program, false).execute();

      new Pass1EarlyConstantIdentification(program).execute();
      new PassNAssertConstantModification(program).execute();
      new PassNAssertTypeDeref(program).check();

      if(getLog().isVerbosePass1CreateSsa()) {
         getLog().append("CONTROL FLOW GRAPH BEFORE INLINING");
         getLog().append(program.getGraph().toString(program));
      }
      new Pass1ProcedureInline(program).execute();
      new PassNStatementIndices(program).step();
      program.clearCallGraph();
      new Pass1AssertNoRecursion(program).execute();
      new Pass1AssertInterrupts(program).execute();

      if(getLog().isVerbosePass1CreateSsa()) {
         getLog().append("INITIAL CONTROL FLOW GRAPH");
         getLog().append(program.getGraph().toString(program));
      }

      new Pass1EliminateUncalledProcedures(program).execute();
      new PassNEliminateUnusedVars(program, false).execute();
      new Pass1ExtractInlineStrings(program).execute();
      new PassNCullEmptyBlocks(program).execute();

      new Pass1ModifiedVarsAnalysis(program).execute();
      if(getLog().isVerbosePass1CreateSsa()) {
         getLog().append("PROCEDURE MODIFY VARIABLE ANALYSIS");
         getLog().append(program.getProcedureModifiedVars().toString(program));
      }

      //getLog().append("CONTROL FLOW GRAPH (CLEANED)");
      //getLog().append(program.getGraph().toString(program));

      new Pass1ProcedureCallParameters(program).generate();
      new PassNUnwindLValueLists(program).execute();
      //new Pass1PointifyMemoryVariables(program).execute();

      //getLog().append("CONTROL FLOW GRAPH (CALL PARAMETERS)");
      //getLog().append(program.getGraph().toString(program));

      new Pass1GenerateSingleStaticAssignmentForm(program).execute();

      //getLog().append("CONTROL FLOW GRAPH (SSA)");
      //getLog().append(program.getGraph().toString(program));

      program.setGraph(new Pass1ProcedureCallsReturnValue(program).generate());
      new PassNUnwindLValueLists(program).execute();

      getLog().append("\nCONTROL FLOW GRAPH SSA");
      getLog().append(program.getGraph().toString(program));

      getLog().append("SYMBOL TABLE SSA");
      getLog().append(program.getScope().toString(program, false));

      program.endPass1();

   }

   private void pass2AssertSSA() {
      List<Pass2SsaAssertion> assertions = new ArrayList<>();
      //assertions.add(new Pass2AssertNoLValueObjectEquality(program));
      assertions.add(new PassNAssertTypeDeref(program));
      assertions.add(new Pass2AssertTypeMatch(program));
      assertions.add(new Pass2AssertSymbols(program));
      assertions.add(new Pass2AssertBlocks(program));
      assertions.add(new Pass2AssertNoCallParameters(program));
      assertions.add(new Pass2AssertNoCallLvalues(program));
      assertions.add(new Pass2AssertNoReturnValues(program));
      assertions.add(new Pass2AssertNoProcs(program));
      assertions.add(new Pass2AssertNoLabels(program));
      assertions.add(new Pass2AssertSingleAssignment(program));
      assertions.add(new Pass2AssertRValues(program));
      assertions.add(new Pass2AssertPhiPredecessors(program));
      for(Pass2SsaAssertion assertion : assertions) {
         assertion.check();
      }
   }

   private List<PassStep> getPass2Optimizations() {
      List<PassStep> optimizations = new ArrayList<>();
      optimizations.add(new Pass2FixInlineConstructors(program));
      optimizations.add(new PassNAddNumberTypeConversions(program));
      optimizations.add(new Pass2InlineCast(program));
      optimizations.add(new PassNCastSimplification(program));
      optimizations.add(new PassNFinalizeNumberTypeConversions(program));
      optimizations.add(new PassNTypeInference(program));
      optimizations.add(new PassNAddTypeConversionAssignment(program, true));
      optimizations.add(new PassNTypeIdSimplification(program));
      optimizations.add(new PassNSizeOfSimplification(program));
      optimizations.add(new PassNStatementIndices(program));
      optimizations.add(() -> {
         program.clearVariableReferenceInfos();
         return false;
      });
      optimizations.add(new Pass2UnaryNotSimplification(program));
      optimizations.add(new Pass2AliasElimination(program));
      optimizations.add(new Pass2IdenticalPhiElimination(program));
      optimizations.add(new Pass2DuplicateRValueIdentification(program));
      optimizations.add(new Pass2ConditionalJumpSimplification(program));
      optimizations.add(new Pass2ConditionalAndOrRewriting(program));
      optimizations.add(new PassNAddBooleanCasts(program));
      optimizations.add(new PassNStructPointerRewriting(program));
      optimizations.add(new PassNStructAddressOfRewriting(program));
      optimizations.add(new PassNArrayElementAddressOfRewriting(program));
      optimizations.add(new Pass2ConditionalJumpSequenceImprovement(program));
      optimizations.add(new Pass2ConstantRValueConsolidation(program));
      optimizations.add(new Pass2ConstantIdentification(program));
      optimizations.add(new Pass2ConstantValues(program));
      optimizations.add(new Pass2ConstantCallPointerIdentification(program));
      optimizations.add(new Pass2ConstantIfs(program));
      optimizations.add(new Pass2ConstantStringConsolidation(program));
      optimizations.add(new Pass2RangeResolving(program));
      optimizations.add(new Pass2ComparisonOptimization(program));
      optimizations.add(new Pass2InlineDerefIdx(program));
      optimizations.add(new Pass2DeInlineWordDerefIdx(program));
      optimizations.add(new PassNSimplifyConstantZero(program));
      optimizations.add(new PassNSimplifyExpressionWithZero(program));
      optimizations.add(new PassNEliminateUnusedVars(program, true));
      optimizations.add(new Pass2EliminateUnusedBlocks(program));
      if(enableLoopHeadConstant) {
         optimizations.add(new PassNStatementIndices(program));
         optimizations.add(() -> { program.clearDominators(); return false; });
         optimizations.add(() -> { program.clearLoopSet(); return false; });
         optimizations.add(new Pass2LoopHeadConstantIdentification(program));
         optimizations.add(() -> { program.clearStatementIndices(); return false; });
      }
      return optimizations;
   }

   private void pass2Optimize() {

      if(getLog().isVerboseSizeInfo()) {
         getLog().append(program.getSizeInfo());
      }

      List<PassStep> optimizations = getPass2Optimizations();
      pass2Execute(optimizations);
   }

   private void pass2UnrollLoops() {
      List<PassStep> loopUnrolling = new ArrayList<>();
      loopUnrolling.add(new PassNStatementIndices(program));
      loopUnrolling.add(() -> {
         program.clearVariableReferenceInfos();
         return false;
      });
      loopUnrolling.add(() -> {
         program.clearStatementInfos();
         return false;
      });
      loopUnrolling.add(() -> {
         program.clearDominators();
         return false;
      });
      loopUnrolling.add(() -> {
         program.clearLoopSet();
         return false;
      });
      loopUnrolling.add(new Pass2LoopUnroll(program));

      if(getLog().isVerboseLoopUnroll()) {
         getLog().append("CONTROL FLOW GRAPH BEFORE UNROLLING");
         getLog().append(program.getGraph().toString(program));
      }

      boolean unrolled;
      do {
         unrolled = pass2ExecuteOnce(loopUnrolling);
         if(unrolled) {
            if(getLog().isVerboseLoopUnroll()) {
               getLog().append("UNROLLED CONTROL FLOW GRAPH");
               getLog().append(program.getGraph().toString(program));
            }
            pass2Optimize();
            new Pass2LoopUnrollAssertComplete(program).step();
            new PassNBlockSequencePlanner(program).step();
         }
      } while(unrolled);

   }

   private void pass2InlineConstants() {

      if(getLog().isVerboseSizeInfo()) {
         getLog().append(program.getSizeInfo());
      }

      // Constant inlining optimizations - as the last step to ensure that constant identification has been completed
      List<PassStep> constantOptimizations = new ArrayList<>();
      constantOptimizations.add(new PassNStatementIndices(program));
      constantOptimizations.add(() -> {
         program.clearVariableReferenceInfos();
         return false;
      });
      constantOptimizations.add(new Pass2NopCastInlining(program));
      constantOptimizations.add(new Pass2MultiplyToShiftRewriting(program));
      constantOptimizations.add(new Pass2ConstantInlining(program));
      constantOptimizations.add(new Pass2ArrayInStructInlining(program));
      constantOptimizations.add(new Pass2ConstantAdditionElimination(program));
      constantOptimizations.add(new Pass2ConstantSimplification(program));
      constantOptimizations.addAll(getPass2Optimizations());
      pass2Execute(constantOptimizations);

   }

   /**
    * Execute optimization steps repeatedly until none of them performs an optimization anymore
    *
    * @param optimizations The optimizations to repeat
    */
   private void pass2Execute(List<PassStep> optimizations) {
      boolean ssaOptimized = true;
      while(ssaOptimized) {
         pass2AssertSSA();
         ssaOptimized = false;
         for(PassStep optimization : optimizations) {
            boolean stepOptimized = true;
            while(stepOptimized) {
               stepOptimized = optimization.step();
               ssaOptimized = pass2LogOptimization(ssaOptimized, optimization, stepOptimized);
            }
         }
      }
   }

   /**
    * Repeat a set of optimizations steps once each.
    *
    * @param optimizations The optimizations
    * @return true if any step performed an optimization
    */
   private boolean pass2ExecuteOnce(List<PassStep> optimizations) {
      boolean ssaOptimized = false;
      for(PassStep optimization : optimizations) {
         pass2AssertSSA();
         boolean stepOptimized = optimization.step();
         ssaOptimized = pass2LogOptimization(ssaOptimized, optimization, stepOptimized);
      }
      return ssaOptimized;
   }

   private boolean pass2LogOptimization(boolean ssaOptimized, PassStep optimization, boolean stepOptimized) {
      if(stepOptimized) {
         getLog().append("Successful SSA optimization " + optimization.getClass().getSimpleName() + "");
         ssaOptimized = true;
         if(getLog().isVerboseSSAOptimize()) {
            getLog().append("CONTROL FLOW GRAPH");
            getLog().append(program.getGraph().toString(program));
         }
      }
      return ssaOptimized;
   }

   private void pass3Analysis() {

      if(getLog().isVerboseSizeInfo()) {
         getLog().append(program.getSizeInfo());
      }

      new Pass3AssertNoTypeId(program).check();
      new Pass3AssertRValues(program).check();
      new Pass3AssertNoNumbers(program).check();
      new Pass3AssertConstants(program).check();
      new Pass3AssertArrayLengths(program).check();
      new Pass3AssertNoMulDivMod(program).check();
      // Phi lifting ensures that all variables in phi-blocks are in different live range equivalence classes
      new Pass3PhiLifting(program).perform();
      new PassNBlockSequencePlanner(program).step();
      //getLog().append("CONTROL FLOW GRAPH - PHI LIFTED");
      //getLog().append(program.getGraph().toString(program));
      pass2AssertSSA();
      new Pass3AddNopBeforeCallOns(program).generate();
      new PassNStatementIndices(program).execute();

      getLog().append("CALL GRAPH");
      program.clearCallGraph();
      getLog().append(program.getCallGraph().toString());

      //getLog().setVerboseLiveRanges(true);

      program.clearStatementInfos();
      program.clearVariableReferenceInfos();
      //getLog().append("CONTROL FLOW GRAPH - LIVE RANGES FOUND");
      //getLog().append(program.getGraph().toString(program));
      pass2AssertSSA();

      //getLog().setVerboseLiveRanges(false);

      // Phi mem coalesce removes as many variables introduced by phi lifting as possible - as long as their live ranges do not overlap
      new Pass3PhiMemCoalesce(program).step();
      new PassNCullEmptyBlocks(program).step();
      new PassNRenumberLabels(program).execute();
      new PassNBlockSequencePlanner(program).step();
      new Pass3AddNopBeforeCallOns(program).generate();
      new PassNStatementIndices(program).execute();

      // Handle calling convention stack
      new PassNCallingConventionStack(program).execute();

      program.clearCallGraph();
      program.clearStatementIndices();
      program.clearStatementInfos();
      program.clearVariableReferenceInfos();
      program.clearLiveRangeVariables();
      program.clearLiveRangeVariablesEffective();
      new PassNStatementIndices(program).execute();
      pass2AssertSSA();

      getLog().append("\nFINAL CONTROL FLOW GRAPH");
      getLog().append(program.getGraph().toString(program));

   }

   private void pass4RegisterAllocation() {

      if(getLog().isVerboseSizeInfo()) {
         getLog().append(program.getSizeInfo());
      }

      if(getLog().isVerboseLoopAnalysis()) {
         getLog().append("DOMINATORS");
      }
      program.clearDominators();
      if(getLog().isVerboseLoopAnalysis()) {
         getLog().append(program.getDominators().toString());
      }

      if(getLog().isVerboseLoopAnalysis()) {
         getLog().append("NATURAL LOOPS");
      }
      program.clearLoopSet();
      if(getLog().isVerboseLoopAnalysis()) {
         getLog().append(program.getLoopSet().toString());
      }

      if(getLog().isVerboseLoopAnalysis()) {
         getLog().append("NATURAL LOOPS WITH DEPTH");
      }
      new Pass3LoopDepthAnalysis(program).findLoopDepths();
      if(getLog().isVerboseLoopAnalysis()) {
         getLog().append(program.getLoopSet().toString());
      }

      getLog().append("\nVARIABLE REGISTER WEIGHTS");
      program.getVariableRegisterWeights();
      getLog().append(program.getScope().toString(program, true));

      new Pass4LiveRangeEquivalenceClassesFinalize(program).allocate();
      new Pass4RegistersFinalize(program).allocate(true);

      // Initial Code generation
      new Pass4CodeGeneration(program, false, program.isWarnFragmentMissing()).generate();
      new Pass4AssertNoCpuClobber(program).check();
      getLog().append("\nINITIAL ASM");
      getLog().append("Target platform is " + program.getTargetPlatform().getName() + " / " +program.getTargetCpu().getName().toUpperCase(Locale.ENGLISH));
      getLog().append(program.getAsm().toString(new AsmProgram.AsmPrintState(true), program));

      if(disableUplift) {
         getLog().append("REGISTER UPLIFT DISABLED!");
      } else {
         // Find potential registers for each live range equivalence class - based on clobbering of fragments
         getLog().append("REGISTER UPLIFT POTENTIAL REGISTERS");
         new Pass4RegisterUpliftPotentialInitialize(program).initPotentialRegisters();
         new Pass4RegisterUpliftPotentialAluAnalysis(program).findPotentialAlu();
         boolean change;
         do {
            change = new Pass4RegisterUpliftPotentialRegisterAnalysis(program).findPotentialRegisters();
         } while(change);
         getLog().append(program.getRegisterPotentials().toString());

         if(getLog().isVerboseSizeInfo()) {
            getLog().append(program.getSizeInfo());
         }

         // Find register uplift scopes
         getLog().append("REGISTER UPLIFT SCOPES");
         getLog().append(program.getRegisterUpliftProgram().toString((program.getVariableRegisterWeights())));

         // Attempt uplifting registers through a lot of combinations
         //getLog().setVerboseUplift(true);
         new Pass4RegisterUpliftCombinations(program).performUplift(upliftCombinations);

         //getLog().setVerboseUplift(true);
         //new Pass4RegisterUpliftStatic(program).performUplift();
         //getLog().setVerboseUplift(false);

         // Attempt uplifting registers one at a time to catch remaining potential not realized by combination search
         new Pass4RegisterUpliftRemains(program).performUplift(upliftCombinations);
      }

      // Register coalesce on assignment (saving bytes & cycles)
      new Pass4MemoryCoalesceAssignment(program).coalesce();

      // Register coalesce on call graph (saving ZP)
      new Pass4MemoryCoalesceCallGraph(program).coalesce();

      if(enableZeroPageCoalasce) {
         // Register coalesce using exhaustive search (saving even more ZP - but slow)
         new Pass4MemoryCoalesceExhaustive(program).coalesce();
      }
      new Pass4RegistersFinalize(program).allocate(true);
      new Pass4AssertZeropageAllocation(program).check();

      // Final ASM code generation before optimization
      program.clearPhiTransitions();
      new Pass4CodeGeneration(program, false, program.isWarnFragmentMissing()).generate();
      new Pass4AssertNoCpuClobber(program).check();

      // Remove unnecessary register savings from interrupts {@link InterruptType#HARDWARE_NOCLOBBER}
      new Pass4InterruptClobberFix(program).fix();

      program.endPass4();

   }

   private void pass5GenerateAndOptimizeAsm() {

      getLog().append("\nASSEMBLER BEFORE OPTIMIZATION");
      getLog().append(program.getAsm().toString(new AsmProgram.AsmPrintState(true), program));

      getLog().append("ASSEMBLER OPTIMIZATIONS");
      List<Pass5AsmOptimization> pass5Optimizations = new ArrayList<>();
      pass5Optimizations.add(new Pass5NextJumpElimination(program));
      pass5Optimizations.add(new Pass5UnnecesaryLoadElimination(program));
      pass5Optimizations.add(new Pass5RedundantLabelElimination(program));
      pass5Optimizations.add(new Pass5UnusedLabelElimination(program));
      pass5Optimizations.add(new Pass5SkipBegin(program));
      pass5Optimizations.add(new Pass5DoubleJumpElimination(program));
      pass5Optimizations.add(new Pass5UnreachableCodeElimination(program));
      pass5Optimizations.add(new Pass5RelabelLongLabels(program));
      pass5Optimizations.add(new Pass5SkipBegin(program));
      pass5Optimizations.add(new Pass5AddMainRts(program));
      boolean asmOptimized = true;
      while(asmOptimized) {
         asmOptimized = false;
         for(Pass5AsmOptimization optimization : pass5Optimizations) {
            boolean stepOptimized = optimization.optimize();
            if(stepOptimized) {
               getLog().append("Succesful ASM optimization " + optimization.getClass().getSimpleName());
               asmOptimized = true;
               if(getLog().isVerboseAsmOptimize()) {
                  getLog().append("ASSEMBLER");
                  getLog().append(program.getAsm().toString());
               }
            }
         }
      }

      new Pass5ReindexAsmLines(program).optimize();
      new Pass5FixLongBranches(program).optimize();

      getLog().append("\nFINAL SYMBOL TABLE");
      getLog().append(program.getScope().toString(program, false));

      getLog().append("\nFINAL ASSEMBLER");
      getLog().append("Score: " + Pass4RegisterUpliftCombinations.getAsmScore(program) + "\n");
      getLog().append(program.getAsm().toString(new AsmProgram.AsmPrintState(false, true, true, false), program));

   }

}
