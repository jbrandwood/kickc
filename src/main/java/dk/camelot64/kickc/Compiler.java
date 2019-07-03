package dk.camelot64.kickc;

import dk.camelot64.kickc.model.Comment;
import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.StatementSequence;
import dk.camelot64.kickc.model.statements.StatementCall;
import dk.camelot64.kickc.model.statements.StatementSource;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.values.SymbolRef;
import dk.camelot64.kickc.parser.KickCLexer;
import dk.camelot64.kickc.parser.KickCParser;
import dk.camelot64.kickc.passes.*;
import org.antlr.v4.runtime.*;

import java.io.File;
import java.io.IOException;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;

/**
 * Perform KickC compilation and optimizations
 */
public class Compiler {

   private Program program;

   /** The number of combinations to test when uplifting variables into registers. */
   private int upliftCombinations = 100;

   /** Enable the zero-page coalesce pass. It takes a lot of time, but limits the zero page usage significantly. */
   private boolean enableZeroPageCoalasce = false;

   public Compiler() {
      this.program = new Program();
   }

   public void setUpliftCombinations(int upliftCombinations) {
      this.upliftCombinations = upliftCombinations;
   }

   public void setEnableZeroPageCoalasce(boolean optimizeZeroPageCoalesce) {
      this.enableZeroPageCoalasce = optimizeZeroPageCoalesce;
   }

   public void setLog(CompileLog compileLog) {
      program.setLog(compileLog);
   }


   public static void loadAndParseFile(String fileName, Program program, Path currentPath) {
      try {
         if(!fileName.endsWith(".kc")) {
            fileName += ".kc";
         }
         File file = loadFile(fileName, currentPath, program);
         List<String> imported = program.getImported();
         if(imported.contains(file.getAbsolutePath())) {
            return;
         }
         final CharStream fileStream = CharStreams.fromPath(file.toPath());
         imported.add(file.getAbsolutePath());
         if(program.getLog().isVerboseParse()) {
            program.getLog().append("PARSING " + file.getPath().replace("\\", "/"));
            program.getLog().append(fileStream.toString());
         }
         KickCLexer lexer = new KickCLexer(fileStream);
         lexer.addErrorListener(new BaseErrorListener() {
            @Override
            public void syntaxError(
                  Recognizer<?, ?> recognizer,
                  Object offendingSymbol,
                  int line,
                  int charPositionInLine,
                  String msg,
                  RecognitionException e) {
               throw new CompileError("Error parsing  file " + fileStream.getSourceName() + "\n - Line: " + line + "\n - Message: " + msg);
            }
         });
         CommonTokenStream tokenStream = new CommonTokenStream(lexer);
         KickCParser parser = new KickCParser(tokenStream);
         parser.setBuildParseTree(true);
         parser.addErrorListener(new BaseErrorListener() {
            @Override
            public void syntaxError(
                  Recognizer<?, ?> recognizer,
                  Object offendingSymbol,
                  int line,
                  int charPositionInLine,
                  String msg,
                  RecognitionException e) {
               throw new CompileError("Error parsing  file " + fileStream.getSourceName() + "\n - Line: " + line + "\n - Message: " + msg);
            }
         });
         Pass0GenerateStatementSequence pass0GenerateStatementSequence = new Pass0GenerateStatementSequence(file, tokenStream, parser.file(), program);
         pass0GenerateStatementSequence.generate();
      } catch(IOException e) {
         throw new CompileError("Error loading file " + fileName, e);
      }
   }

   public static File loadFile(String fileName, Path currentPath, Program program) {
      List<String> searchPaths = new ArrayList<>();
      searchPaths.add(currentPath.toString());
      searchPaths.addAll(program.getImportPaths());
      for(String importPath : searchPaths) {
         if(!importPath.endsWith("/")) {
            importPath += "/";
         }
         String filePath = importPath + fileName;
         //System.out.println("Looking for file "+filePath);
         File file = new File(filePath);
         if(file.exists()) {
            //System.out.println("Found file "+file.getAbsolutePath()+" in import path "+importPath);
            return file;
         }
      }
      throw new CompileError("File  not found " + fileName);
   }

   public CompileLog getLog() {
      return program.getLog();
   }

   public void addImportPath(String path) {
      program.getImportPaths().add(path);
   }

   public Program compile(String fileName) {
      program.setFileName(fileName);
      program.setStatementSequence(new StatementSequence());
      try {
         File currentPath = new File(".");
         loadAndParseFile(fileName, program, currentPath.toPath());

         StatementSequence sequence = program.getStatementSequence();
         sequence.addStatement(new StatementCall(null, SymbolRef.MAIN_PROC_NAME, new ArrayList<>(), new StatementSource(RuleContext.EMPTY), Comment.NO_COMMENTS));
         program.setStatementSequence(sequence);

         pass1GenerateSSA();
         pass2Optimize();
         pass2UnrollLoops();
         pass2InlineConstants();
         pass3Analysis();
         pass4RegisterAllocation();
         pass5GenerateAndOptimizeAsm();
         return program;
      } catch(Exception e) {
         throw e;
      }
   }

   private Program pass1GenerateSSA() {

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

      if(getLog().isVerbosePass1CreateSsa()) {
         getLog().append("SYMBOLS");
         getLog().append(program.getScope().toString(program, null));
      }

      new Pass1AddressOfVolatile(program).execute();
      new Pass1FixLValuesLoHi(program).execute();
      new Pass1AssertNoLValueIntermediate(program).execute();
      new PassNAddTypeConversionAssignment(program, false).execute();
      new Pass1AssertProcedureCallParameters(program).execute();

      new Pass1PointerSizeofFix(program).execute(); // After this point in the code all pointer math is byte-based
      new PassNSizeOfSimplification(program).execute(); // Needed to eliminate sizeof() referencing pointer value variables

      new Pass1UnwindStructValues(program).execute();
      new PassNStructPointerRewriting(program).execute();

      new PassNAddBooleanCasts(program).execute();
      new PassNAddTypeConversionAssignment(program, false).execute();

      new Pass1EarlyConstantIdentification(program).execute();
      new Pass1ProcedureInline(program).execute();
      new PassNStatementIndices(program).step();
      new PassNCallGraphAnalysis(program).step();
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

      //getLog().append("CONTROL FLOW GRAPH (CALL PARAMETERS)");
      //getLog().append(program.getGraph().toString(program));

      new Pass1GenerateSingleStaticAssignmentForm(program).execute();

      //getLog().append("CONTROL FLOW GRAPH (SSA)");
      //getLog().append(program.getGraph().toString(program));

      program.setGraph(new Pass1ProcedureCallsReturnValue(program).generate());
      new PassNUnwindLValueLists(program).execute();
      new Pass1UnwindStructVersions(program).execute();

      getLog().append("\nCONTROL FLOW GRAPH SSA");
      getLog().append(program.getGraph().toString(program));

      getLog().append("SYMBOL TABLE SSA");
      getLog().append(program.getScope().toString(program, null));

      return program;
   }

   private void pass2AssertSSA() {
      List<Pass2SsaAssertion> assertions = new ArrayList<>();
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

   private List<Pass2SsaOptimization> getPass2Optimizations() {
      List<Pass2SsaOptimization> optimizations = new ArrayList<>();
      optimizations.add(new Pass2FixInlineConstructorsNew(program));
      optimizations.add(new PassNAddNumberTypeConversions(program));
      optimizations.add(new PassNAddArrayNumberTypeConversions(program));
      optimizations.add(new Pass2InlineCast(program));
      optimizations.add(new PassNCastSimplification(program));
      optimizations.add(new PassNFinalizeNumberTypeConversions(program));
      optimizations.add(new PassNTypeInference(program));
      optimizations.add(new PassNAddTypeConversionAssignment(program, true));
      optimizations.add(new PassNTypeIdSimplification(program));
      optimizations.add(new PassNSizeOfSimplification(program));
      optimizations.add(new PassNStatementIndices(program));
      optimizations.add(new PassNVariableReferenceInfos(program));
      optimizations.add(new Pass2UnaryNotSimplification(program));
      optimizations.add(new Pass2AliasElimination(program));
      optimizations.add(new Pass2SelfPhiElimination(program));
      optimizations.add(new Pass2IdenticalPhiElimination(program));
      optimizations.add(new Pass2DuplicateRValueIdentification(program));
      optimizations.add(new Pass2ConditionalJumpSimplification(program));
      optimizations.add(new Pass2ConditionalAndOrRewriting(program));
      optimizations.add(new PassNAddBooleanCasts(program));
      optimizations.add(new PassNStructPointerRewriting(program));
      optimizations.add(new PassNStructAddressOfRewriting(program));
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
      return optimizations;
   }

   private void pass2Optimize() {
      List<Pass2SsaOptimization> optimizations = getPass2Optimizations();
      pass2Execute(optimizations);
   }

   private void pass2UnrollLoops() {
      List<Pass2SsaOptimization> loopUnrolling = new ArrayList<>();
      loopUnrolling.add(new PassNStatementIndices(program));
      loopUnrolling.add(new PassNVariableReferenceInfos(program));
      loopUnrolling.add(new PassNStatementInfos(program));
      loopUnrolling.add(new PassNDominatorsAnalysis(program));
      loopUnrolling.add(new PassNLoopAnalysis(program));
      loopUnrolling.add(new Pass2LoopUnrollPhiPrepare(program));
      loopUnrolling.add(new Pass2LoopUnroll(program));

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
      // Constant inlining optimizations - as the last step to ensure that constant identification has been completed
      List<Pass2SsaOptimization> constantOptimizations = new ArrayList<>();
      constantOptimizations.add(new PassNStatementIndices(program));
      constantOptimizations.add(new PassNVariableReferenceInfos(program));
      constantOptimizations.add(new Pass2NopCastInlining(program));
      constantOptimizations.add(new Pass2MultiplyToShiftRewriting(program));
      constantOptimizations.add(new Pass2ConstantInlining(program));
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
   private void pass2Execute(List<Pass2SsaOptimization> optimizations) {
      boolean ssaOptimized = true;
      while(ssaOptimized) {
         pass2AssertSSA();
         ssaOptimized = false;
         for(Pass2SsaOptimization optimization : optimizations) {
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
   private boolean pass2ExecuteOnce(List<Pass2SsaOptimization> optimizations) {
      boolean ssaOptimized = false;
      for(Pass2SsaOptimization optimization : optimizations) {
         pass2AssertSSA();
         boolean stepOptimized = optimization.step();
         ssaOptimized = pass2LogOptimization(ssaOptimized, optimization, stepOptimized);
      }
      return ssaOptimized;
   }

   private boolean pass2LogOptimization(boolean ssaOptimized, Pass2SsaOptimization optimization, boolean stepOptimized) {
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
      new PassNCallGraphAnalysis(program).step();
      getLog().append(program.getCallGraph().toString());

      //getLog().setVerboseLiveRanges(true);

      new PassNStatementInfos(program).execute();
      new PassNVariableReferenceInfos(program).execute();
      new Pass3LiveRangesAnalysis(program).findLiveRanges();
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
      new PassNCallGraphAnalysis(program).step();
      new PassNStatementInfos(program).execute();
      new PassNVariableReferenceInfos(program).execute();
      new Pass3SymbolInfos(program).generateSymbolInfos();
      new Pass3LiveRangesAnalysis(program).findLiveRanges();
      new Pass3LiveRangesEffectiveAnalysis(program).findLiveRangesEffective();
      pass2AssertSSA();

      getLog().append("\nFINAL CONTROL FLOW GRAPH");
      getLog().append(program.getGraph().toString(program));

   }

   private void pass4RegisterAllocation() {

      if(getLog().isVerboseLoopAnalysis()) {
         getLog().append("DOMINATORS");
      }
      new PassNDominatorsAnalysis(program).step();
      if(getLog().isVerboseLoopAnalysis()) {
         getLog().append(program.getDominators().toString());
      }

      if(getLog().isVerboseLoopAnalysis()) {
         getLog().append("NATURAL LOOPS");
      }
      new PassNLoopAnalysis(program).step();
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
      new Pass3VariableRegisterWeightAnalysis(program).findWeights();
      getLog().append(program.getScope().toString(program, Variable.class));

      new Pass4LiveRangeEquivalenceClassesFinalize(program).allocate();
      new Pass4RegistersFinalize(program).allocate(true);

      // Initial Code generation
      new Pass4PhiTransitions(program).generate();
      new Pass4CodeGeneration(program, false).generate();
      new Pass4AssertNoCpuClobber(program).check();
      getLog().append("\nINITIAL ASM");
      getLog().append(program.getAsm().toString());

      // Find potential registers for each live range equivalence class - based on clobbering of fragments
      getLog().append("REGISTER UPLIFT POTENTIAL REGISTERS");
      new Pass4RegisterUpliftPotentialInitialize(program).initPotentialRegisters();
      new Pass4RegisterUpliftPotentialAluAnalysis(program).findPotentialAlu();
      boolean change;
      do {
         change = new Pass4RegisterUpliftPotentialRegisterAnalysis(program).findPotentialRegisters();
      } while(change);
      getLog().append(program.getRegisterPotentials().toString());

      // Find register uplift scopes
      getLog().append("REGISTER UPLIFT SCOPES");
      new Pass4RegisterUpliftScopeAnalysis(program).findScopes();
      getLog().append(program.getRegisterUpliftProgram().toString((program.getVariableRegisterWeights())));

      // Attempt uplifting registers through a lot of combinations
      //getLog().setVerboseUplift(true);
      new Pass4RegisterUpliftCombinations(program).performUplift(upliftCombinations);

      //getLog().setVerboseUplift(true);
      //new Pass4RegisterUpliftStatic(program).performUplift();
      //getLog().setVerboseUplift(false);

      // Attempt uplifting registers one at a time to catch remaining potential not realized by combination search
      new Pass4RegisterUpliftRemains(program).performUplift(upliftCombinations);

      // Final register coalesce and finalization
      new Pass4ZeroPageCoalesceAssignment(program).coalesce();
      if(enableZeroPageCoalasce) {
         new Pass4ZeroPageCoalesce(program).coalesce();
      }
      new Pass4RegistersFinalize(program).allocate(true);

   }

   private void pass5GenerateAndOptimizeAsm() {

      // Final ASM code generation before optimization
      new Pass4PhiTransitions(program).generate();
      new Pass4CodeGeneration(program, false).generate();
      new Pass4AssertNoCpuClobber(program).check();

      // Remove unnecessary register savings from interrupts {@link InterruptType#HARDWARE_NOCLOBBER}
      new Pass4InterruptClobberFix(program).fix();

      getLog().append("\nASSEMBLER BEFORE OPTIMIZATION");
      getLog().append(program.getAsm().toString());

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
      getLog().append(program.getScope().toString(program, null));

      getLog().append("\nFINAL ASSEMBLER");
      getLog().append("Score: " + Pass4RegisterUpliftCombinations.getAsmScore(program) + "\n");
      getLog().append(program.getAsm().toString());

   }

}
