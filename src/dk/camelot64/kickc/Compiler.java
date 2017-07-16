package dk.camelot64.kickc;

import dk.camelot64.kickc.asm.AsmProgram;
import dk.camelot64.kickc.icl.*;
import dk.camelot64.kickc.parser.KickCLexer;
import dk.camelot64.kickc.parser.KickCParser;
import org.antlr.v4.runtime.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/** Perform KickC compilation and optimizations*/
public class Compiler {

   public static class CompilationResult {
      private AsmProgram asmProgram;
      private ControlFlowGraph graph;
      private Scope symbols;
      private CompileLog log;

      public CompilationResult(AsmProgram asmProgram, ControlFlowGraph graph, Scope symbols, CompileLog log) {
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

      public Scope getSymbols() {
         return symbols;
      }

      public CompileLog getLog() {
         return log;
      }
   }

   public CompilationResult compile(final CharStream input) {
      CompileLog log = new CompileLog();
      try {
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
         KickCParser.FileContext file = parser.file();
         Pass1GenerateStatementSequence pass1GenerateStatementSequence = new Pass1GenerateStatementSequence(log);
         pass1GenerateStatementSequence.generate(file);
         StatementSequence statementSequence = pass1GenerateStatementSequence.getSequence();
         Scope programScope = pass1GenerateStatementSequence.getProgramScope();
         Pass1TypeInference pass1TypeInference = new Pass1TypeInference();
         pass1TypeInference.inferTypes(statementSequence, programScope);

         log.append("PROGRAM");
         log.append(statementSequence.toString());
         log.append("SYMBOLS");
         log.append(programScope.getSymbolTableContents());

         Pass1GenerateControlFlowGraph pass1GenerateControlFlowGraph = new Pass1GenerateControlFlowGraph(programScope);
         ControlFlowGraph controlFlowGraph = pass1GenerateControlFlowGraph.generate(statementSequence);
         log.append("INITIAL CONTROL FLOW GRAPH");
         log.append(controlFlowGraph.toString());

         Pass1ProcedureCallParameters pass1ProcedureCallParameters =
               new Pass1ProcedureCallParameters(programScope, controlFlowGraph);
         controlFlowGraph = pass1ProcedureCallParameters.generate();
         log.append("CONTROL FLOW GRAPH WITH ASSIGNMENT CALL");
         log.append(controlFlowGraph.toString());

         Pass1GenerateSingleStaticAssignmentForm pass1GenerateSingleStaticAssignmentForm =
               new Pass1GenerateSingleStaticAssignmentForm(log, programScope, controlFlowGraph);
         pass1GenerateSingleStaticAssignmentForm.generate();

         log.append("CONTROL FLOW GRAPH SSA");
         log.append(controlFlowGraph.toString());

         Pass1ProcedureCallsReturnValue pass1ProcedureCallsReturnValue =
               new Pass1ProcedureCallsReturnValue(programScope, controlFlowGraph);
         controlFlowGraph = pass1ProcedureCallsReturnValue.generate();
         log.append("CONTROL FLOW GRAPH WITH ASSIGNMENT CALL & RETURN");
         log.append(controlFlowGraph.toString());

         List<Pass2SsaOptimization> optimizations = new ArrayList<>();
         optimizations.add(new Pass2CullEmptyBlocks(controlFlowGraph, programScope, log));
         optimizations.add(new Pass2ConstantPropagation(controlFlowGraph, programScope, log));
         optimizations.add(new Pass2ConstantAdditionElimination(controlFlowGraph, programScope, log));
         optimizations.add(new Pass2AliasElimination(controlFlowGraph, programScope, log));
         optimizations.add(new Pass2RedundantPhiElimination(controlFlowGraph, programScope, log));
         optimizations.add(new Pass2SelfPhiElimination(controlFlowGraph, programScope, log));
         optimizations.add(new Pass2ConditionalJumpSimplification(controlFlowGraph, programScope, log));

         List<Pass2SsaAssertion> assertions = new ArrayList<>();
         assertions.add(new Pass2AssertSymbols(controlFlowGraph, programScope));
         assertions.add(new Pass2AssertBlocks(controlFlowGraph, programScope));

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
                  log.append(controlFlowGraph.toString());
               }
            }
         }

         Pass3BlockSequencePlanner pass3BlockSequencePlanner = new Pass3BlockSequencePlanner(
               controlFlowGraph,
               programScope);
         pass3BlockSequencePlanner.plan();
         Pass3RegisterAllocation pass3RegisterAllocation = new Pass3RegisterAllocation(controlFlowGraph, programScope);
         pass3RegisterAllocation.allocate();
         Pass3CodeGeneration pass3CodeGeneration = new Pass3CodeGeneration(controlFlowGraph, programScope);
         AsmProgram asmProgram = pass3CodeGeneration.generate();

         log.append("INITIAL ASM");
         log.append(asmProgram.toString());

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

         log.append("FINAL SYMBOL TABLE");
         log.append(programScope.getSymbolTableContents());
         log.append("FINAL CODE");
         log.append(asmProgram.toString());

         return new CompilationResult(asmProgram, controlFlowGraph, programScope, log);
      } catch (Exception e) {
         System.out.println(log.getLog());
         throw e;
      }
   }

}
