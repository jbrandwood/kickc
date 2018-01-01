package dk.camelot64.kickc;

import dk.camelot64.kickc.model.*;
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
         File file = loadFile(fileName, program);
         List<String> imported = program.getImported();
         if(imported.contains(file.getAbsolutePath())) {
            return;
         }
         final CharStream fileStream = CharStreams.fromPath(file.toPath());
         imported.add(file.getAbsolutePath());
         program.getLog().append("PARSING " + file.getPath());
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

   private static File loadFile(String fileName, Program program) {
      if(!fileName.endsWith(".kc")) {
         fileName += ".kc";
      }
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
      try {
         Pass0GenerateStatementSequence pass0GenerateStatementSequence = new Pass0GenerateStatementSequence(program);
         loadAndParseFile(fileName, program, pass0GenerateStatementSequence);
         StatementSequence sequence = pass0GenerateStatementSequence.getSequence();
         sequence.addStatement(new StatementCall(null, "main", new ArrayList<>()));
         program.setStatementSequence(sequence);
         pass1GenerateSSA();
         pass2OptimizeSSA();
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

      new Pass1TypeInference(program).execute();
      getLog().append("\nSTATEMENTS");
      getLog().append(program.getStatementSequence().toString(program));
      getLog().append("SYMBOLS");
      getLog().append(program.getScope().getSymbolTableContents(program));

      new Pass1GenerateControlFlowGraph(program).execute();
      new Pass1FixLValuesLoHi(program).execute();
      new Pass1AssertNoLValueIntermediate(program).execute();
      new Pass1AddTypePromotions(program).execute();
      new Pass1AssertArrayLengths(program).execute();

      getLog().append("INITIAL CONTROL FLOW GRAPH");
      getLog().append(program.getGraph().toString(program));

      new Pass1AssertReturn(program).execute();
      new Pass1AssertUsedVars(program).execute();

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
      for(Pass2SsaAssertion assertion : assertions) {
         assertion.check();
      }
   }

   private void pass2OptimizeSSA() {
      List<Pass2SsaOptimization> optimizations = new ArrayList<>();
      optimizations.add(new Pass2CullEmptyBlocks(program));
      optimizations.add(new Pass2UnaryNotSimplification(program));
      optimizations.add(new Pass2AliasElimination(program));
      optimizations.add(new Pass2SelfPhiElimination(program));
      optimizations.add(new Pass2RedundantPhiElimination(program));
      optimizations.add(new Pass2ConditionalJumpSimplification(program));
      optimizations.add(new Pass2ConstantIdentification(program));
      optimizations.add(new Pass2ConstantAdditionElimination(program));
      optimizations.add(new Pass2FixWordConstructors(program));
      optimizations.add(new PassNEliminateUnusedVars(program));
      pass2OptimizeSSA(optimizations);

      // Constant inlining optimizations - as the last step to ensure that constant identification has been completed
      List<Pass2SsaOptimization> constantOptimizations = new ArrayList<>();
      constantOptimizations.add(new Pass2ConstantInlining(program));
      pass2OptimizeSSA(constantOptimizations);

   }

   private void pass2OptimizeSSA(List<Pass2SsaOptimization> optimizations) {
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
                  getLog().append("Succesful SSA optimization " + optimization.getClass().getSimpleName() + "");
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

   private void pass3Analysis() {

      new Pass3AssertNoValueLists(program).check();
      new Pass3BlockSequencePlanner(program).plan();
      // Phi lifting ensures that all variables in phi-blocks are in different live range equivalence classes
      new Pass3PhiLifting(program).perform();
      new Pass3BlockSequencePlanner(program).plan();
      //getLog().append("CONTROL FLOW GRAPH - PHI LIFTED");
      //getLog().append(program.getGraph().toString(program));
      pass2AssertSSA();
      new Pass3AddNopBeforeCallOns(program).generate();
      new PassNStatementIndices(program).generateStatementIndices();

      getLog().append("CALL GRAPH");
      new Pass3CallGraphAnalysis(program).findCallGraph();
      getLog().append(program.getCallGraph().toString());

      //getLog().setVerboseLiveRanges(true);

      new Pass3StatementInfos(program).generateStatementInfos();
      new PassNVariableReferenceInfos(program).generateVariableReferenceInfos();
      new Pass3LiveRangesAnalysis(program).findLiveRanges();
      //getLog().append("CONTROL FLOW GRAPH - LIVE RANGES FOUND");
      //getLog().append(program.getGraph().toString(program));
      pass2AssertSSA();

      //getLog().setVerboseLiveRanges(false);

      // Phi mem coalesce removes as many variables introduced by phi lifting as possible - as long as their live ranges do not overlap
      new Pass3PhiMemCoalesce(program).step();
      new Pass2CullEmptyBlocks(program).step();
      new Pass3BlockSequencePlanner(program).plan();
      new Pass3AddNopBeforeCallOns(program).generate();
      new PassNStatementIndices(program).generateStatementIndices();
      new Pass3CallGraphAnalysis(program).findCallGraph();
      new Pass3StatementInfos(program).generateStatementInfos();
      new PassNVariableReferenceInfos(program).generateVariableReferenceInfos();
      new Pass3SymbolInfos(program).generateSymbolInfos();
      new Pass3LiveRangesAnalysis(program).findLiveRanges();
      //getLog().append("CONTROL FLOW GRAPH - BEFORE EFFECTIVE LIVE RANGES");
      //getLog().append(program.getGraph().toString(program));
      new Pass3LiveRangesEffectiveAnalysis(program).findLiveRangesEffective();
      pass2AssertSSA();

      getLog().append("\nFINAL CONTROL FLOW GRAPH");
      getLog().append(program.getGraph().toString(program));


   }

   private void pass4RegisterAllocation() {

      getLog().append("DOMINATORS");
      new Pass3DominatorsAnalysis(program).findDominators();
      getLog().append(program.getDominators().toString());

      getLog().append("NATURAL LOOPS");
      new Pass3LoopAnalysis(program).findLoops();
      getLog().append(program.getLoopSet().toString());

      getLog().append("NATURAL LOOPS WITH DEPTH");
      new Pass3LoopDepthAnalysis(program).findLoopDepths();
      getLog().append(program.getLoopSet().toString());

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
      new Pass4RegisterUpliftCombinations(program).performUplift(10_000);

      //getLog().setVerboseUplift(true);
      //new Pass4RegisterUpliftStatic(program).performUplift();
      //getLog().setVerboseUplift(false);

      // Attempt uplifting registers one at a time to catch remaining potential not realized by combination search
      new Pass4RegisterUpliftRemains(program).performUplift(10_000);

      // Final register coalesce and finalization
      new Pass4ZeroPageCoalesce(program).allocate();
      new Pass4RegistersFinalize(program).allocate(true);

   }

   private void pass5GenerateAndOptimizeAsm() {

      // Final ASM code generation before optimization
      new Pass4CodeGeneration(program, true).generate();
      new Pass4AssertNoCpuClobber(program).check();

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

      getLog().append("\nFINAL SYMBOL TABLE");
      getLog().append(program.getScope().getSymbolTableContents(program));

      getLog().append("\nFINAL ASSEMBLER");
      getLog().append("Score: " + Pass4RegisterUpliftCombinations.getAsmScore(program) + "\n");
      getLog().append(program.getAsm().toString());

   }

}
