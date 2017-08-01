package dk.camelot64.kickc;

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


   public Program compile(final CharStream input) {
      CompileLog log = new CompileLog();
      try {
         KickCParser.FileContext file = pass0ParseInput(input, log);
         Program program = pass1GenerateSSA(file, log);
         pass2OptimizeSSA(program);
         pass3RegisterAllocation(program);
         pass5OptimizeAsm(program);

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

   public void pass5OptimizeAsm(Program program) {
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


   private void pass3RegisterAllocation(Program program) {

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
      program.getLog().append(program.getScope().getSymbolTableContents(program ,Variable.class));

      new Pass3ZeroPageAllocation(program).allocate();
      new Pass3RegistersFinalize(program).allocate();

      // Initial Code generation
      new Pass3CodeGeneration(program).generate();
      new Pass3AssertNoCpuClobber(program).check();
      program.getLog().append("INITIAL ASM");
      program.getLog().append(program.getAsm().toString());

      // Register allocation optimization
      new Pass3RegisterUplifting(program).uplift();
      program.getLog().append("REGISTER UPLIFTING");
      program.getLog().append(program.getScope().getSymbolTableContents(program, Variable.class));
      new Pass3AssertNoCpuClobber(program).check();

      // Final register coalesce and code generation
      new Pass3ZeroPageCoalesce(program).allocate();
      new Pass3CodeGeneration(program).generate();
      new Pass3AssertNoCpuClobber(program).check();

      //new Pass3CustomRegisters(program).setRegister();
      //new Pass3AssertNoCpuClobber(program).check();

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
