package dk.camelot64.kickc;

import dk.camelot64.kickc.asm.AsmProgram;
import dk.camelot64.kickc.icl.*;
import dk.camelot64.kickc.parser.KickCLexer;
import dk.camelot64.kickc.parser.KickCParser;
import dk.camelot64.kickc.passes.*;
import org.antlr.v4.runtime.*;

import java.util.ArrayList;
import java.util.List;

/**
 * Perform KickC compilation and optimizations
 */
public class Compiler {

   public static class CompilationResult {
      private AsmProgram asmProgram;
      private ControlFlowGraph graph;
      private ProgramScope scope;
      private CompileLog log;

      public CompilationResult(AsmProgram asmProgram, ControlFlowGraph graph, ProgramScope scope, CompileLog log) {
         this.asmProgram = asmProgram;
         this.graph = graph;
         this.scope = scope;
         this.log = log;
      }

      public AsmProgram getAsmProgram() {
         return asmProgram;
      }

      public ControlFlowGraph getGraph() {
         return graph;
      }

      public ProgramScope getScope() {
         return scope;
      }

      public CompileLog getLog() {
         return log;
      }
   }

   public CompilationResult compile(final CharStream input) {
      CompileLog log = new CompileLog();
      try {
         KickCParser.FileContext file = pass0ParseInput(input, log);
         Program program = pass1GenerateSSA(file, log);
         pass2OptimizeSSA(program, log);
         pass3RegisterAllocation(program, log);
         AsmProgram asmProgram = pass4GenerateAsm(program, log);
         pass5OptimizeAsm(asmProgram, log);

         log.append("FINAL SYMBOL TABLE");
         log.append(program.getScope().getSymbolTableContents());
         log.append("FINAL CODE");
         log.append(asmProgram.toString());

         return new CompilationResult(asmProgram, program.getGraph(), program.getScope(), log);
      } catch (Exception e) {
         System.out.println(log.getLog());
         throw e;
      }
   }

   public void pass5OptimizeAsm(AsmProgram asmProgram, CompileLog log) {
      List<Pass5AsmOptimization> pass5Optimizations = new ArrayList<>();
      pass5Optimizations.add(new Pass5NextJumpElimination(asmProgram, log));
      pass5Optimizations.add(new Pass5UnnecesaryLoadElimination(asmProgram, log));
      boolean asmOptimized = true;
      while (asmOptimized) {
         asmOptimized = false;
         for (Pass5AsmOptimization optimization : pass5Optimizations) {
            boolean stepOptimized = optimization.optimize();
            if (stepOptimized) {
               log.append("Succesful ASM optimization " + optimization.getClass().getSimpleName());
               asmOptimized = true;
               log.append("ASSEMBLER");
               log.append(asmProgram.toString());
            }
         }
      }
   }

   public AsmProgram pass4GenerateAsm(Program program, CompileLog log) {

      Pass4CodeGeneration pass4CodeGeneration = new Pass4CodeGeneration(program);
      AsmProgram asmProgram = pass4CodeGeneration.generate();

      log.append("INITIAL ASM");
      log.append(asmProgram.toString());
      return asmProgram;
   }


   private void pass3RegisterAllocation(Program program, CompileLog log) {

      new Pass3BlockSequencePlanner(program, log).plan();

      // Phi lifting ensures that all variables in phi-blocks are in different live range equivalence classes
      new Pass3PhiLifting(program, log).perform();
      new Pass3BlockSequencePlanner(program, log).plan();
      log.append("CONTROL FLOW GRAPH - PHI LIFTED");
      log.append(program.getGraph().toString(program.getScope()));
      pass2AssertSSA(program, log);

      new Pass3LiveRangesAnalysis(program, log).findLiveRanges();
      log.append("CONTROL FLOW GRAPH - LIVE RANGES");
      log.append(program.getGraph().toString(program.getScope()));
      pass2AssertSSA(program, log);

      // Phi mem coalesce removes as many variables introduced by phi lifting as possible - as long as their live ranges do not overlap
      new Pass3PhiMemCoalesce(program, log).optimize();
      new Pass2CullEmptyBlocks(program, log).optimize();
      new Pass3BlockSequencePlanner(program, log).plan();
      new Pass3LiveRangesAnalysis(program, log).findLiveRanges();
      log.append("CONTROL FLOW GRAPH - PHI MEM COALESCED");
      log.append(program.getGraph().toString(program.getScope()));
      pass2AssertSSA(program, log);

      new Pass3CallGraphAnalysis(program, log).findCallGraph();
      log.append("CALL GRAPH");
      log.append(program.getGraph().getCallGraph().toString());

      new Pass3DominatorsAnalysis(program, log).findDominators();
      log.append("DOMINATORS");
      log.append(program.getGraph().getDominators().toString());

      new Pass3LoopAnalysis(program, log).findLoops();
      log.append("NATURAL LOOPS");
      log.append(program.getGraph().getLoopSet().toString());

      new Pass3LoopDepthAnalysis(program, log).findLoopDepths();
      log.append("NATURAL LOOPS WITH DEPTH");
      log.append(program.getGraph().getLoopSet().toString());

      new Pass3ZeroPageAllocation(program, log).allocate();

      new Pass3VariableRegisterWeightAnalysis(program, log).findWeights();
      log.append("\nVARIABLE REGISTER WEIGHTS");
      log.append(program.getScope().getSymbolTableContents(Variable.class));

      new Pass3RegistersFinalize(program, log).allocate();

      new Pass3AssertNoCpuClobber(program, log).check();

      new Pass3RegisterUplifting(program, log).uplift();
      log.append("REGISTER UPLIFTING");
      log.append(program.getScope().getSymbolTableContents(Variable.class));
      new Pass3AssertNoCpuClobber(program, log).check();

      new Pass3ZeroPageCoalesce(program, log).allocate();
      new Pass3AssertNoCpuClobber(program, log).check();

      //new Pass4CustomRegisters(program).allocate();
      //new Pass3AssertNoCpuClobber(program, log).check();

   }

   public void pass2OptimizeSSA(Program program, CompileLog log) {
      List<Pass2SsaOptimization> optimizations = new ArrayList<>();
      optimizations.add(new Pass2CullEmptyBlocks(program, log));
      optimizations.add(new Pass2ConstantPropagation(program, log));
      optimizations.add(new Pass2ConstantAdditionElimination(program, log));
      optimizations.add(new Pass2AliasElimination(program, log));
      optimizations.add(new Pass2RedundantPhiElimination(program, log));
      optimizations.add(new Pass2SelfPhiElimination(program, log));
      optimizations.add(new Pass2ConditionalJumpSimplification(program, log));

      boolean ssaOptimized = true;
      while (ssaOptimized) {
         pass2AssertSSA(program, log);
         ssaOptimized = false;
         for (Pass2SsaOptimization optimization : optimizations) {
            boolean stepOptimized = optimization.optimize();
            if (stepOptimized) {
               log.append("Succesful SSA optimization " + optimization.getClass().getSimpleName() + "");
               ssaOptimized = true;
               log.append("CONTROL FLOW GRAPH");
               log.append(program.getGraph().toString(program.getScope()));
            }
         }
      }
   }

   public void pass2AssertSSA(Program program, CompileLog log) {
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

      log.append("PROGRAM");
      log.append(statementSequence.toString(programScope));
      log.append("SYMBOLS");
      log.append(programScope.getSymbolTableContents());

      Pass1GenerateControlFlowGraph pass1GenerateControlFlowGraph = new Pass1GenerateControlFlowGraph(programScope);
      ControlFlowGraph controlFlowGraph = pass1GenerateControlFlowGraph.generate(statementSequence);

      Program program = new Program(programScope, controlFlowGraph);

      log.append("INITIAL CONTROL FLOW GRAPH");
      log.append(program.getGraph().toString(program.getScope()));

      Pass1EliminateEmptyBlocks pass1EliminateEmptyBlocks = new Pass1EliminateEmptyBlocks(program, log);
      boolean blockEliminated = pass1EliminateEmptyBlocks.eliminate();
      if (blockEliminated) {
         log.append("CONTROL FLOW GRAPH");
         log.append(program.getGraph().toString(program.getScope()));
      }

      Pass1ProcedureCallParameters pass1ProcedureCallParameters =
            new Pass1ProcedureCallParameters(program);
      program.setGraph(pass1ProcedureCallParameters.generate());
      log.append("CONTROL FLOW GRAPH WITH ASSIGNMENT CALL");
      log.append(program.getGraph().toString(program.getScope()));

      Pass1GenerateSingleStaticAssignmentForm pass1GenerateSingleStaticAssignmentForm =
            new Pass1GenerateSingleStaticAssignmentForm(log, program);
      pass1GenerateSingleStaticAssignmentForm.generate();

      log.append("CONTROL FLOW GRAPH SSA");
      log.append(program.getGraph().toString(program.getScope()));

      Pass1ProcedureCallsReturnValue pass1ProcedureCallsReturnValue =
            new Pass1ProcedureCallsReturnValue(program);
      program.setGraph(pass1ProcedureCallsReturnValue.generate());
      log.append("CONTROL FLOW GRAPH WITH ASSIGNMENT CALL & RETURN");
      log.append(program.getGraph().toString(program.getScope()));
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
