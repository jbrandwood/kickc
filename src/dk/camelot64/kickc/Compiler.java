package dk.camelot64.kickc;

import dk.camelot64.kickc.asm.AsmProgram;
import dk.camelot64.kickc.icl.*;
import dk.camelot64.kickc.parser.KickCLexer;
import dk.camelot64.kickc.parser.KickCParser;
import dk.camelot64.kickc.passes.*;
import org.antlr.v4.runtime.*;

import java.util.ArrayList;
import java.util.List;

/** Perform KickC compilation and optimizations*/
public class Compiler {

   public static class CompilationResult {
      private AsmProgram asmProgram;
      private ControlFlowGraph graph;
      private ProgramScope symbols;
      private CompileLog log;

      public CompilationResult(AsmProgram asmProgram, ControlFlowGraph graph, ProgramScope symbols, CompileLog log) {
         this.asmProgram = asmProgram;
         this.graph = graph;
         this.symbols = symbols;
         this.log = log;
      }

      public AsmProgram getAsmProgram() {
         return asmProgram;
      }

      public ControlFlowGraph getGraph() {
         return graph;
      }

      public ProgramScope getSymbols() {
         return symbols;
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
         AsmProgram asmProgram = pass3GenerateAsm(program, log);
         pass4OptimizeAsm(asmProgram, log);

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

   public void pass4OptimizeAsm(AsmProgram asmProgram, CompileLog log) {
      List<Pass4AsmOptimization> pass4Optimizations = new ArrayList<>();
      pass4Optimizations.add(new Pass4NextJumpElimination(asmProgram, log));
      pass4Optimizations.add(new Pass4UnnecesaryLoadElimination(asmProgram, log));
      boolean asmOptimized = true;
      while (asmOptimized) {
         asmOptimized = false;
         for (Pass4AsmOptimization optimization : pass4Optimizations) {
            boolean stepOtimized = optimization.optimize();
            if (stepOtimized) {
               log.append("Succesful ASM optimization " + optimization.getClass().getSimpleName());
               asmOptimized = true;
               log.append("ASSEMBLER");
               log.append(asmProgram.toString());
            }
         }
      }
   }

   public  AsmProgram pass3GenerateAsm(Program program, CompileLog log) {
      Pass3BlockSequencePlanner pass3BlockSequencePlanner = new Pass3BlockSequencePlanner(program);
      pass3BlockSequencePlanner.plan();
      Pass3RegisterAllocation pass3RegisterAllocation = new Pass3RegisterAllocation(program);
      pass3RegisterAllocation.allocate();
      Pass3CodeGeneration pass3CodeGeneration = new Pass3CodeGeneration(program);
      AsmProgram asmProgram = pass3CodeGeneration.generate();

      log.append("INITIAL ASM");
      log.append(asmProgram.toString());
      return asmProgram;
   }

   public  void pass2OptimizeSSA(Program program, CompileLog log) {
      List<Pass2SsaOptimization> optimizations = new ArrayList<>();
      optimizations.add(new Pass2CullEmptyBlocks(program, log));
      optimizations.add(new Pass2ConstantPropagation(program, log));
      optimizations.add(new Pass2ConstantAdditionElimination(program, log));
      optimizations.add(new Pass2AliasElimination(program, log));
      optimizations.add(new Pass2RedundantPhiElimination(program, log));
      optimizations.add(new Pass2SelfPhiElimination(program, log));
      optimizations.add(new Pass2ConditionalJumpSimplification(program, log));

      List<Pass2SsaAssertion> assertions = new ArrayList<>();
      assertions.add(new Pass2AssertSymbols(program));
      assertions.add(new Pass2AssertBlocks(program));

      boolean ssaOptimized = true;
      while (ssaOptimized) {
         for (Pass2SsaAssertion assertion : assertions) {
            assertion.check();
         }
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

   public  Program pass1GenerateSSA(KickCParser.FileContext file, CompileLog log) {
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
         if(blockEliminated) {
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

   public  KickCParser.FileContext pass0ParseInput(final CharStream input, CompileLog log) {
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
