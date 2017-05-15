package dk.camelot64.kickc.test;

import dk.camelot64.kickc.icl.*;
import dk.camelot64.kickc.parser.KickCLexer;
import dk.camelot64.kickc.parser.KickCParser;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;

import java.io.IOException;
import java.io.LineNumberReader;
import java.util.ArrayList;
import java.util.List;

/** Test my KickC Grammar */
public class Main {
   public static void main(String[] args) throws IOException {
      CharStream input = CharStreams.fromFileName("src/dk/camelot64/kickc/test/test.kc");
      System.out.println(input.toString());
      KickCLexer lexer = new KickCLexer(input);
      KickCParser parser = new KickCParser(new CommonTokenStream(lexer));
      parser.setBuildParseTree(true);
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

      System.out.println("SYMBOLS");
      System.out.println(symbolTable.toString());
      System.out.println("CONTROL FLOW GRAPH");
      System.out.println(controlFlowGraph.toString());


      Pass1GenerateSingleStaticAssignmentForm pass1GenerateSingleStaticAssignmentForm =
            new Pass1GenerateSingleStaticAssignmentForm(symbolTable, controlFlowGraph);
      pass1GenerateSingleStaticAssignmentForm.generate();

      List<Pass2Optimization> optimizations = new ArrayList<>();
      optimizations.add(new Pass2CullEmptyBlocks(controlFlowGraph, symbolTable));
      optimizations.add(new Pass2ConstantPropagation(controlFlowGraph, symbolTable));
      optimizations.add(new Pass2AliasElimination(controlFlowGraph, symbolTable));
      optimizations.add(new Pass2RedundantPhiElimination(controlFlowGraph, symbolTable));
      optimizations.add(new Pass2SelfPhiElimination(controlFlowGraph, symbolTable));

      boolean optimized = true;
      while (optimized) {
         optimized = false;
         for (Pass2Optimization optimization : optimizations) {
            boolean stepOptimized = optimization.optimize();
            if (stepOptimized) {
               System.out.println("Succesful optimization "+optimization);
               optimized = true;
            }
         }
      }

      Pass3RegisterAllocation pass3RegisterAllocation = new Pass3RegisterAllocation(controlFlowGraph, symbolTable);
      pass3RegisterAllocation.allocate();

      System.out.println("SYMBOLS");
      System.out.println(symbolTable.toString());
      System.out.println("CONTROL FLOW GRAPH");
      System.out.println(controlFlowGraph.toString());
   }

}
