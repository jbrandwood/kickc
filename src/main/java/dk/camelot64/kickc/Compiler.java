package dk.camelot64.kickc;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.StatementSequence;
import dk.camelot64.kickc.model.statements.StatementCall;
import dk.camelot64.kickc.model.statements.StatementSource;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.parser.KickCLexer;
import dk.camelot64.kickc.parser.KickCParser;
import dk.camelot64.kickc.passes.*;
import org.antlr.v4.runtime.*;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * Perform KickC compilation and optimizations
 */
public class Compiler {

   private Program program;

   public Compiler() {
      this.program = new Program();
   }

   public static void loadAndParseFile(String fileName, Program program, Pass0GenerateStatementSequence pass0GenerateStatementSequence) {
      try {
         if(!fileName.endsWith(".kc")) {
            fileName += ".kc";
         }
         File file = loadFile(fileName, program);
         List<String> imported = program.getImported();
         if(imported.contains(file.getAbsolutePath())) {
            return;
         }
         final CharStream fileStream = CharStreams.fromPath(file.toPath());
         imported.add(file.getAbsolutePath());
         program.getLog().append("PARSING " + file.getPath().replace("\\", "/"));
         program.getLog().append(fileStream.toString());
         KickCLexer lexer = new KickCLexer(fileStream);
         KickCParser parser = new KickCParser(new CommonTokenStream(lexer));
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
         pass0GenerateStatementSequence.generate(parser.file());
      } catch(IOException e) {
         throw new CompileError("Error loading file " + fileName, e);
      }
   }

   public static File loadFile(String fileName, Program program) {
      List<String> importPaths = program.getImportPaths();
      for(String importPath : importPaths) {
         if(!importPath.endsWith("/")) {
            importPath += "/";
         }
         String filePath = importPath + fileName;
         File file = new File(filePath);
         if(file.exists()) {
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

   public Program compile(String fileName) throws IOException {
      program.setFileName(fileName);
      try {
         Pass0GenerateStatementSequence pass0GenerateStatementSequence = new Pass0GenerateStatementSequence(program);
         loadAndParseFile(fileName, program, pass0GenerateStatementSequence);
         StatementSequence sequence = pass0GenerateStatementSequence.getSequence();
         sequence.addStatement(new StatementCall(null, "main", new ArrayList<>(), new StatementSource(RuleContext.EMPTY)));
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
         System.out.println("EXCEPTION DURING COMPILE " + e.getMessage());
         System.out.println(getLog().toString());
         throw e;
      }
   }

   private Program pass1GenerateSSA() {

      //getLog().append("\nSTATEMENTS");
      //getLog().append(program.getStatementSequence().toString(program));

      new Pass1GenerateControlFlowGraph(program).execute();
      new Pass1ResolveForwardReferences(program).execute();
      new Pass1TypeInference(program).execute();

      getLog().append("SYMBOLS");
      getLog().append(program.getScope().getSymbolTableContents(program));

      new Pass1FixLValuesLoHi(program).execute();
      new Pass1AssertNoLValueIntermediate(program).execute();
      new Pass1AddTypePromotions(program).execute();
      new Pass1AssertNoRecursion(program).execute();
      new Pass1AssertInterrupts(program).execute();

      getLog().append("INITIAL CONTROL FLOW GRAPH");
      getLog().append(program.getGraph().toString(program));

      new Pass1AssertReturn(program).execute();
      new Pass1AssertUsedVars(program).execute();

      new Pass1ProcedureInline(program).execute();
      //getLog().append("INLINED CONTROL FLOW GRAPH");
      //getLog().append(program.getGraph().toString(program));

      new Pass1EliminateUncalledProcedures(program).execute();
      new PassNEliminateUnusedVars(program).execute();
      new Pass1ExtractInlineStrings(program).execute();
      new Pass1EliminateEmptyBlocks(program).execute();

      //getLog().append("CONTROL FLOW GRAPH");
      //getLog().append(program.getGraph().toString(program));

      getLog().append("PROCEDURE MODIFY VARIABLE ANALYSIS");
      new Pass1ModifiedVarsAnalysis(program).execute();
      getLog().append(program.getProcedureModifiedVars().toString(program));

      new Pass1ProcedureCallParameters(program).generate();
      //getLog().append("CONTROL FLOW GRAPH WITH ASSIGNMENT CALL");
      //getLog().append(program.getGraph().toString(program));

      new Pass1GenerateSingleStaticAssignmentForm(program).execute();

      //getLog().append("CONTROL FLOW GRAPH SSA");
      //getLog().append(program.getGraph().toString(program));

      program.setGraph(new Pass1ProcedureCallsReturnValue(program).generate());

      getLog().append("\nCONTROL FLOW GRAPH SSA WITH ASSIGNMENT CALL & RETURN");
      getLog().append(program.getGraph().toString(program));

      getLog().append("SYMBOL TABLE SSA");
      getLog().append(program.getScope().getSymbolTableContents(program));

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
      for(Pass2SsaAssertion assertion : assertions) {
         assertion.check();
      }
   }

   private void pass2Optimize() {
      List<Pass2SsaOptimization> optimizations = new ArrayList<>();
      optimizations.add(new Pass2CullEmptyBlocks(program));
      optimizations.add(new Pass2UnaryNotSimplification(program));
      optimizations.add(new Pass2AliasElimination(program));
      optimizations.add(new Pass2SelfPhiElimination(program));
      optimizations.add(new Pass2RedundantPhiElimination(program));
      optimizations.add(new Pass2IdenticalPhiElimination(program));
      optimizations.add(new Pass2ConditionalJumpSimplification(program));
      optimizations.add(new Pass2ConditionalAndOrRewriting(program));
      optimizations.add(new Pass2ConstantIdentification(program));
      optimizations.add(new Pass2ConstantAdditionElimination(program));
      optimizations.add(new Pass2ConstantIfs(program));
      optimizations.add(new Pass2FixInlineConstructors(program));
      optimizations.add(new Pass2TypeInference(program));
      optimizations.add(new PassNEliminateUnusedVars(program));
      optimizations.add(new Pass2NopCastElimination(program));
      optimizations.add(new Pass2EliminateUnusedBlocks(program));
      optimizations.add(new Pass2RangeResolving(program));
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
      constantOptimizations.add(new Pass2ConstantInlining(program));
      constantOptimizations.add(new Pass2IdenticalPhiElimination(program));
      constantOptimizations.add(new Pass2ConstantIdentification(program));
      constantOptimizations.add(new Pass2ConstantAdditionElimination(program));
      constantOptimizations.add(new Pass2ConstantSimplification(program));
      constantOptimizations.add(new Pass2ConstantIfs(program));
      pass2Execute(constantOptimizations);
   }

   /**
    * Execute optimization steps repeatedly until none of them performs an optimization anymore
    *
    * @param optimizations The optimizations to repeat
    */
   private void pass2Execute(List<Pass2SsaOptimization> optimizations) {
      getLog().append("OPTIMIZING CONTROL FLOW GRAPH");
      boolean ssaOptimized = true;
      while(ssaOptimized) {
         pass2AssertSSA();
         ssaOptimized = false;
         for(Pass2SsaOptimization optimization : optimizations) {
            boolean stepOptimized = true;
            while(stepOptimized) {
               stepOptimized = optimization.step();
               if(stepOptimized) {
                  getLog().append("Successful SSA optimization " + optimization.getClass().getSimpleName() + "");
                  ssaOptimized = true;
                  if(getLog().isVerboseSSAOptimize()) {
                     getLog().append("CONTROL FLOW GRAPH");
                     getLog().append(program.getGraph().toString(program));
                  }
               }
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
         if(stepOptimized) {
            getLog().append("Successful SSA optimization " + optimization.getClass().getSimpleName() + "");
            ssaOptimized = true;
            if(getLog().isVerboseSSAOptimize()) {
               getLog().append("CONTROL FLOW GRAPH");
               getLog().append(program.getGraph().toString(program));
            }
         }
      }
      return ssaOptimized;
   }

   private void pass3Analysis() {

      new Pass3AssertRValues(program).check();
      new Pass3AssertConstants(program).check();
      new Pass3AssertArrayLengths(program).check();
      new Pass3AssertNoMulDivMod(program).check();
      new PassNBlockSequencePlanner(program).step();
      // Phi lifting ensures that all variables in phi-blocks are in different live range equivalence classes
      new Pass3PhiLifting(program).perform();
      new PassNBlockSequencePlanner(program).step();
      //getLog().append("CONTROL FLOW GRAPH - PHI LIFTED");
      //getLog().append(program.getGraph().toString(program));
      pass2AssertSSA();
      new Pass3AddNopBeforeCallOns(program).generate();
      new PassNStatementIndices(program).execute();

      getLog().append("CALL GRAPH");
      new Pass3CallGraphAnalysis(program).findCallGraph();
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
      new Pass2CullEmptyBlocks(program).step();
      new PassNBlockSequencePlanner(program).step();
      new Pass3AddNopBeforeCallOns(program).generate();
      new PassNStatementIndices(program).execute();
      new Pass3CallGraphAnalysis(program).findCallGraph();
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
      new Pass4CodeGeneration(program, true).generate();
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
      new Pass4RegisterUpliftCombinations(program).performUplift(100);

      //getLog().setVerboseUplift(true);
      //new Pass4RegisterUpliftStatic(program).performUplift();
      //getLog().setVerboseUplift(false);

      // Attempt uplifting registers one at a time to catch remaining potential not realized by combination search
      new Pass4RegisterUpliftRemains(program).performUplift(100);

      // Final register coalesce and finalization
      new Pass4ZeroPageCoalesceAssignment(program).coalesce();
      new Pass4ZeroPageCoalesce(program).coalesce();
      new Pass4RegistersFinalize(program).allocate(true);

   }

   private void pass5GenerateAndOptimizeAsm() {

      // Final ASM code generation before optimization
      new Pass4CodeGeneration(program, true).generate();
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
      pass5Optimizations.add(new Pass5DoubleJumpElimination(program));
      pass5Optimizations.add(new Pass5UnreachableCodeElimination(program));
      pass5Optimizations.add(new Pass5RelabelLongLabels(program));
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
      getLog().append(program.getScope().getSymbolTableContents(program));

      getLog().append("\nFINAL ASSEMBLER");
      getLog().append("Score: " + Pass4RegisterUpliftCombinations.getAsmScore(program) + "\n");
      getLog().append(program.getAsm().toString());

   }

}
