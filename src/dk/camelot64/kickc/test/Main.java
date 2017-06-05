package dk.camelot64.kickc.test;

import dk.camelot64.kickc.asm.AsmProgram;
import dk.camelot64.kickc.icl.*;
import dk.camelot64.kickc.parser.KickCLexer;
import dk.camelot64.kickc.parser.KickCParser;
import org.antlr.v4.runtime.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/** Test my KickC Grammar */
public class Main {
   public static void main(String[] args) throws IOException {
      final String fileName = "src/dk/camelot64/kickc/test/callsum.kc";
      final CharStream input = CharStreams.fromFileName(fileName);
      System.out.println(input.toString());
      KickCLexer lexer = new KickCLexer(input);
      KickCParser parser = new KickCParser(new CommonTokenStream(lexer));
      parser.setBuildParseTree(true);
      parser.addErrorListener(new BaseErrorListener() {
         @Override
         public void syntaxError(Recognizer<?, ?> recognizer, Object offendingSymbol, int line, int charPositionInLine, String msg, RecognitionException e) {
            throw new RuntimeException("Error parsing  file "+fileName+"\n - Line: "+line+"\n - Message: "+msg);
         }
      });
      KickCParser.FileContext file = parser.file();
      Pass1GenerateStatementSequence pass1GenerateStatementSequence = new Pass1GenerateStatementSequence();
      pass1GenerateStatementSequence.generate(file);
      StatementSequence statementSequence = pass1GenerateStatementSequence.getSequence();
      SymbolTable symbolTable = pass1GenerateStatementSequence.getProgramSymbols();
      new PassTypeInference().inferTypes(statementSequence, symbolTable);

      System.out.println("PROGRAM");
      System.out.println(statementSequence.toString());
      System.out.println("SYMBOLS");
      System.out.println(symbolTable.getSymbolTableContents());

      Pass1GenerateControlFlowGraph pass1GenerateControlFlowGraph = new Pass1GenerateControlFlowGraph(symbolTable);
      ControlFlowGraph controlFlowGraph = pass1GenerateControlFlowGraph.generate(statementSequence);

      Pass1GenerateSingleStaticAssignmentForm pass1GenerateSingleStaticAssignmentForm =
            new Pass1GenerateSingleStaticAssignmentForm(symbolTable, controlFlowGraph);
      pass1GenerateSingleStaticAssignmentForm.generate();

      List<Pass2SsaOptimization> optimizations = new ArrayList<>();
      optimizations.add(new Pass2CullEmptyBlocks(controlFlowGraph, symbolTable));
      optimizations.add(new Pass2ConstantPropagation(controlFlowGraph, symbolTable));
      optimizations.add(new Pass2ConstantAdditionElimination(controlFlowGraph, symbolTable));
      optimizations.add(new Pass2AliasElimination(controlFlowGraph, symbolTable));
      optimizations.add(new Pass2RedundantPhiElimination(controlFlowGraph, symbolTable));
      optimizations.add(new Pass2SelfPhiElimination(controlFlowGraph, symbolTable));
      optimizations.add(new Pass2ConditionalJumpSimplification(controlFlowGraph, symbolTable));

      System.out.println("INITIAL CONTROL FLOW GRAPH");
      System.out.println(controlFlowGraph.toString());

      boolean ssaOptimized = true;
      while (ssaOptimized) {
         ssaOptimized = false;
         for (Pass2SsaOptimization optimization : optimizations) {
            boolean stepOptimized = optimization.optimize();
            if (stepOptimized) {
               System.out.println("Succesful SSA optimization "+optimization);
               ssaOptimized = true;
               System.out.println("CONTROL FLOW GRAPH");
               System.out.println(controlFlowGraph.toString());
            }
         }
      }

      Pass3RegisterAllocation pass3RegisterAllocation = new Pass3RegisterAllocation(controlFlowGraph, symbolTable);
      pass3RegisterAllocation.allocate();
      Pass3CodeGeneration pass3CodeGeneration = new Pass3CodeGeneration(controlFlowGraph, symbolTable);
      AsmProgram asmProgram = pass3CodeGeneration.generate();

      System.out.println("INITIAL ASM");
      System.out.println(asmProgram.toString());

      List<Pass4AsmOptimization> pass4Optimizations = new ArrayList<>();
      pass4Optimizations.add(new Pass4NextJumpElimination(asmProgram));
      pass4Optimizations.add(new Pass4UnnecesaryLoadElimination(asmProgram));
      boolean asmOptimized = true;
      while(asmOptimized) {
         asmOptimized = false;
         for (Pass4AsmOptimization optimization : pass4Optimizations) {
            boolean stepOtimized = optimization.optimize();
            if(stepOtimized) {
               System.out.println("Succesful ASM optimization "+optimization);
               asmOptimized = true;
               System.out.println("ASSEMBLER");
               System.out.println(asmProgram.toString());
            }
         }
      }

      System.out.println("SYMBOLS");
      System.out.println(symbolTable.toString());
      System.out.println("CONTROL FLOW GRAPH");
      System.out.println(controlFlowGraph.toString());
      System.out.println("ASSEMBLER");
      System.out.println(asmProgram.toString());
   }

}
