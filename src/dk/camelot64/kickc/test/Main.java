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
      final String fileName = "src/dk/camelot64/kickc/test/mem.kc";
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
      SymbolTable symbolTable = pass1GenerateStatementSequence.getSymbols();
      new PassTypeInference().inferTypes(statementSequence, symbolTable);

      System.out.println("PROGRAM");
      System.out.println(statementSequence.toString());

      Pass1GenerateControlFlowGraph pass1GenerateControlFlowGraph = new Pass1GenerateControlFlowGraph(symbolTable);
      ControlFlowGraph controlFlowGraph = pass1GenerateControlFlowGraph.generate(statementSequence);

      Pass1GenerateSingleStaticAssignmentForm pass1GenerateSingleStaticAssignmentForm =
            new Pass1GenerateSingleStaticAssignmentForm(symbolTable, controlFlowGraph);
      pass1GenerateSingleStaticAssignmentForm.generate();

      List<Pass2Optimization> optimizations = new ArrayList<>();
      optimizations.add(new Pass2CullEmptyBlocks(controlFlowGraph, symbolTable));
      optimizations.add(new Pass2ConstantPropagation(controlFlowGraph, symbolTable));
      optimizations.add(new Pass2AliasElimination(controlFlowGraph, symbolTable));
      optimizations.add(new Pass2RedundantPhiElimination(controlFlowGraph, symbolTable));
      optimizations.add(new Pass2SelfPhiElimination(controlFlowGraph, symbolTable));
      optimizations.add(new Pass2ConditionalJumpSimplification(controlFlowGraph, symbolTable));

      System.out.println("INITIAL CONTROL FLOW GRAPH");
      System.out.println(controlFlowGraph.toString());

      boolean optimized = true;
      while (optimized) {
         optimized = false;
         for (Pass2Optimization optimization : optimizations) {
            boolean stepOptimized = optimization.optimize();
            if (stepOptimized) {
               System.out.println("Succesful optimization "+optimization);
               optimized = true;
               System.out.println("CONTROL FLOW GRAPH");
               System.out.println(controlFlowGraph.toString());
            }
         }
      }

      Pass3RegisterAllocation pass3RegisterAllocation = new Pass3RegisterAllocation(controlFlowGraph, symbolTable);
      pass3RegisterAllocation.allocate();

      Pass4CodeGeneration pass4CodeGeneration = new Pass4CodeGeneration(controlFlowGraph, symbolTable);
      AsmProgram asmProgram = pass4CodeGeneration.generate();
      Pass5NextJumpElimination pass5NextJumpElimination = new Pass5NextJumpElimination(asmProgram);
      pass5NextJumpElimination.optimize();


      System.out.println("SYMBOLS");
      System.out.println(symbolTable.toString());
      System.out.println("CONTROL FLOW GRAPH");
      System.out.println(controlFlowGraph.toString());
      System.out.println("ASSEMBLER");
      System.out.println(asmProgram.toString());
   }

}
