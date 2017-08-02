package dk.camelot64.kickc;

import dk.camelot64.kickc.asm.AsmFragment;
import dk.camelot64.kickc.asm.AsmProgram;
import dk.camelot64.kickc.asm.AsmSegment;
import dk.camelot64.kickc.icl.*;
import dk.camelot64.kickc.parser.KickCLexer;
import dk.camelot64.kickc.parser.KickCParser;
import dk.camelot64.kickc.passes.*;
import org.antlr.v4.runtime.*;

import java.util.*;

/**
 * Perform KickC compilation and optimizations
 */
public class Compiler {


   public Program compile(final CharStream input) {
      CompileLog log = new CompileLog();
      try {
         KickCParser.FileContext file = pass0ParseInput(input, log);
         Program program = pass1GenerateSSA(file, log);
         pass2OptimizeSSA(program);
         pass3Analysis(program);
         pass4RegisterAllocation(program);
         pass5GenerateAsm(program);
         pass6OptimizeAsm(program);

         log.append("FINAL SYMBOL TABLE");
         log.append(program.getScope().getSymbolTableContents(program));
         log.append("FINAL CODE");
         log.append(program.getAsm().toString());

         return program;
      } catch (Exception e) {
         //System.out.println(log.getLog());
         throw e;
      }
   }

   public void pass6OptimizeAsm(Program program) {
      CompileLog log = program.getLog();
      List<Pass5AsmOptimization> pass5Optimizations = new ArrayList<>();
      pass5Optimizations.add(new Pass5NextJumpElimination(program, log));
      pass5Optimizations.add(new Pass5UnnecesaryLoadElimination(program, log));
      boolean asmOptimized = true;
      while (asmOptimized) {
         asmOptimized = false;
         for (Pass5AsmOptimization optimization : pass5Optimizations) {
            boolean stepOptimized = optimization.optimize();
            if (stepOptimized) {
               log.append("Succesful ASM optimization " + optimization.getClass().getSimpleName());
               asmOptimized = true;
               log.append("ASSEMBLER");
               log.append(program.getAsm().toString());
            }
         }
      }
   }

   private void pass5GenerateAsm(Program program) {
      new Pass3CodeGeneration(program).generate();
      new Pass3AssertNoCpuClobber(program).check();
   }

   private void pass4RegisterAllocation(Program program) {
      // Find register uplift scopes
      new Pass3RegisterUpliftScopeAnalysis(program).findScopes();
      program.getLog().append("REGISTER UPLIFT SCOPES");
      program.getLog().append(program.getRegisterUpliftProgram().toString((program.getVariableRegisterWeights())));

      // Test uplift combinations to find the best one.
      Set<String> unknownFragments = new LinkedHashSet<>();
      for (RegisterUpliftScope upliftScope : program.getRegisterUpliftProgram().getRegisterUpliftScopes()) {
         int bestScore = Integer.MAX_VALUE;
         RegisterUpliftScope.Combination bestCombination = null;

         Iterator<RegisterUpliftScope.Combination> combinationIterator = upliftScope.geCombinationIterator();
         while (combinationIterator.hasNext()) {
            RegisterUpliftScope.Combination combination = combinationIterator.next();
            // Reset register allocation to original zero page allocation
            new Pass3RegistersFinalize(program).allocate(false);
            // Apply the uplift combination
            combination.allocate(program.getAllocation());
            // Generate ASM
            try {
               new Pass3CodeGeneration(program).generate();
            } catch (AsmFragment.UnknownFragmentException e) {
               unknownFragments.add(e.getFragmentSignature());
               StringBuilder msg = new StringBuilder();
               msg.append("Uplift attempt [" + upliftScope.getScopeRef() + "] ");
               msg.append("missing fragment " + e.getFragmentSignature());
               program.getLog().append(msg.toString());
               continue;
            } catch (AsmFragment.AluNotApplicableException e) {
               StringBuilder msg = new StringBuilder();
               msg.append("Uplift attempt [" + upliftScope.getScopeRef() + "] ");
               msg.append("alu not applicable");
               program.getLog().append(msg.toString());
               continue;
            }
            // If no clobber - Find value of the resulting allocation
            boolean hasClobberProblem = new Pass3AssertNoCpuClobber(program).hasClobberProblem(false);
            int combinationScore = getAsmScore(program);
            StringBuilder msg = new StringBuilder();
            msg.append("Uplift attempt [" + upliftScope.getScopeRef() + "] ");
            if (hasClobberProblem) {
               msg.append("clobber");
            } else {
               msg.append(combinationScore);
            }
            msg.append(" allocation: ").append(combination.toString());
            program.getLog().append(msg.toString());
            if (!hasClobberProblem) {
               if (combinationScore < bestScore) {
                  bestScore = combinationScore;
                  bestCombination = combination;
               }
            }
         }
         // Save the best combination in the equivalence class
         bestCombination.store(program.getLiveRangeEquivalenceClassSet());
         program.getLog().append("Uplifting [" + upliftScope.getScopeRef() + "] best " + bestScore + " combination " + bestCombination.toString());
      }

      if (unknownFragments.size() > 0) {
         program.getLog().append("MISSING FRAGMENTS");
         for (String unknownFragment : unknownFragments) {
            program.getLog().append("  " + unknownFragment);
         }
      }

      // Final register coalesce and code generation
      new Pass3ZeroPageCoalesce(program).allocate();
      new Pass3RegistersFinalize(program).allocate(true);

   }

   private int getAsmScore(Program program) {
      int score = 0;
      AsmProgram asm = program.getAsm();
      ControlFlowGraph graph = program.getGraph();
      NaturalLoopSet loopSet = program.getLoopSet();
      for (AsmSegment asmSegment : asm.getSegments()) {
         double asmSegmentCycles = asmSegment.getCycles();
         if (asmSegmentCycles > 0) {
            Integer statementIdx = asmSegment.getStatementIdx();
            ControlFlowBlock block = graph.getBlockFromStatementIdx(statementIdx);
            int maxLoopDepth = loopSet.getMaxLoopDepth(block.getLabel());
            score += asmSegmentCycles * Math.pow(10, maxLoopDepth);
         }
      }
      return score;
   }

   private void pass3Analysis(Program program) {

      new Pass3BlockSequencePlanner(program).plan();

      // Phi lifting ensures that all variables in phi-blocks are in different live range equivalence classes
      new Pass3PhiLifting(program).perform();
      new Pass3BlockSequencePlanner(program).plan();
      program.getLog().append("CONTROL FLOW GRAPH - PHI LIFTED");
      program.getLog().append(program.getGraph().toString(program));
      pass2AssertSSA(program);

      new Pass3LiveRangesAnalysis(program).findLiveRanges();
      program.getLog().append("CONTROL FLOW GRAPH - LIVE RANGES");
      program.getLog().append(program.getGraph().toString(program));
      pass2AssertSSA(program);

      // Phi mem coalesce removes as many variables introduced by phi lifting as possible - as long as their live ranges do not overlap
      new Pass3PhiMemCoalesce(program).optimize();
      new Pass2CullEmptyBlocks(program).optimize();
      new Pass3BlockSequencePlanner(program).plan();
      new Pass3LiveRangesAnalysis(program).findLiveRanges();
      program.getLog().append("CONTROL FLOW GRAPH - PHI MEM COALESCED");
      program.getLog().append(program.getGraph().toString(program));
      pass2AssertSSA(program);

      new Pass3CallGraphAnalysis(program).findCallGraph();
      program.getLog().append("CALL GRAPH");
      program.getLog().append(program.getCallGraph().toString());

      new Pass3DominatorsAnalysis(program).findDominators();
      program.getLog().append("DOMINATORS");
      program.getLog().append(program.getDominators().toString());

      new Pass3LoopAnalysis(program).findLoops();
      program.getLog().append("NATURAL LOOPS");
      program.getLog().append(program.getLoopSet().toString());

      new Pass3LoopDepthAnalysis(program).findLoopDepths();
      program.getLog().append("NATURAL LOOPS WITH DEPTH");
      program.getLog().append(program.getLoopSet().toString());

      new Pass3VariableRegisterWeightAnalysis(program).findWeights();
      program.getLog().append("\nVARIABLE REGISTER WEIGHTS");
      program.getLog().append(program.getScope().getSymbolTableContents(program, Variable.class));

      new Pass3ZeroPageAllocation(program).allocate();
      new Pass3RegistersFinalize(program).allocate(false);

      // Initial Code generation
      new Pass3CodeGeneration(program).generate();
      new Pass3AssertNoCpuClobber(program).check();
      program.getLog().append("INITIAL ASM");
      program.getLog().append(program.getAsm().toString());

   }



   public void pass2OptimizeSSA(Program program) {
      List<Pass2SsaOptimization> optimizations = new ArrayList<>();
      optimizations.add(new Pass2CullEmptyBlocks(program));
      optimizations.add(new Pass2ConstantPropagation(program));
      optimizations.add(new Pass2ConstantAdditionElimination(program));
      optimizations.add(new Pass2AliasElimination(program));
      optimizations.add(new Pass2RedundantPhiElimination(program));
      optimizations.add(new Pass2SelfPhiElimination(program));
      optimizations.add(new Pass2ConditionalJumpSimplification(program));

      boolean ssaOptimized = true;
      while (ssaOptimized) {
         pass2AssertSSA(program);
         ssaOptimized = false;
         for (Pass2SsaOptimization optimization : optimizations) {
            boolean stepOptimized = optimization.optimize();
            if (stepOptimized) {
               program.getLog().append("Succesful SSA optimization " + optimization.getClass().getSimpleName() + "");
               ssaOptimized = true;
               program.getLog().append("CONTROL FLOW GRAPH");
               program.getLog().append(program.getGraph().toString(program));
            }
         }
      }
   }

   public void pass2AssertSSA(Program program) {
      List<Pass2SsaAssertion> assertions = new ArrayList<>();
      assertions.add(new Pass2AssertSymbols(program));
      assertions.add(new Pass2AssertBlocks(program));
      assertions.add(new Pass2AssertNoCallParameters(program));
      assertions.add(new Pass2AssertNoCallLvalues(program));
      assertions.add(new Pass2AssertNoReturnValues(program));
      assertions.add(new Pass2AssertNoProcs(program));
      assertions.add(new Pass2AssertNoLabels(program));
      for (Pass2SsaAssertion assertion : assertions) {
         assertion.check();
      }
   }

   public Program pass1GenerateSSA(KickCParser.FileContext file, CompileLog log) {
      Pass1GenerateStatementSequence pass1GenerateStatementSequence1 = new Pass1GenerateStatementSequence(log);
      pass1GenerateStatementSequence1.generate(file);
      Pass1GenerateStatementSequence pass1GenerateStatementSequence = pass1GenerateStatementSequence1;
      StatementSequence statementSequence = pass1GenerateStatementSequence.getSequence();
      ProgramScope programScope = pass1GenerateStatementSequence.getProgramScope();
      Pass1TypeInference pass1TypeInference = new Pass1TypeInference(programScope);
      pass1TypeInference.inferTypes(statementSequence);

      Program program = new Program(programScope, log);

      log.append("PROGRAM");
      log.append(statementSequence.toString(program));
      log.append("SYMBOLS");
      log.append(programScope.getSymbolTableContents(program));

      Pass1GenerateControlFlowGraph pass1GenerateControlFlowGraph = new Pass1GenerateControlFlowGraph(programScope);
      ControlFlowGraph controlFlowGraph = pass1GenerateControlFlowGraph.generate(statementSequence);

      program.setGraph(controlFlowGraph);

      log.append("INITIAL CONTROL FLOW GRAPH");
      log.append(program.getGraph().toString(program));

      Pass1EliminateEmptyBlocks pass1EliminateEmptyBlocks = new Pass1EliminateEmptyBlocks(program);
      boolean blockEliminated = pass1EliminateEmptyBlocks.eliminate();
      if (blockEliminated) {
         log.append("CONTROL FLOW GRAPH");
         log.append(program.getGraph().toString(program));
      }

      Pass1ProcedureCallParameters pass1ProcedureCallParameters =
            new Pass1ProcedureCallParameters(program);
      program.setGraph(pass1ProcedureCallParameters.generate());
      log.append("CONTROL FLOW GRAPH WITH ASSIGNMENT CALL");
      log.append(program.getGraph().toString(program));

      Pass1GenerateSingleStaticAssignmentForm pass1GenerateSingleStaticAssignmentForm =
            new Pass1GenerateSingleStaticAssignmentForm(log, program);
      pass1GenerateSingleStaticAssignmentForm.generate();

      log.append("CONTROL FLOW GRAPH SSA");
      log.append(program.getGraph().toString(program));

      Pass1ProcedureCallsReturnValue pass1ProcedureCallsReturnValue =
            new Pass1ProcedureCallsReturnValue(program);
      program.setGraph(pass1ProcedureCallsReturnValue.generate());
      log.append("CONTROL FLOW GRAPH WITH ASSIGNMENT CALL & RETURN");
      log.append(program.getGraph().toString(program));
      return program;
   }

   public KickCParser.FileContext pass0ParseInput(final CharStream input, CompileLog log) {
      log.append(input.toString());
      KickCLexer lexer = new KickCLexer(input);
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
            throw new RuntimeException("Error parsing  file " + input.getSourceName() + "\n - Line: " + line + "\n - Message: " + msg);
         }
      });
      return parser.file();
   }

}
