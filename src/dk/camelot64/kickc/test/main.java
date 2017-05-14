package dk.camelot64.kickc.test;

import dk.camelot64.kickc.icl.*;
import dk.camelot64.kickc.parser.KickCLexer;
import dk.camelot64.kickc.parser.KickCParser;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;

import java.io.IOException;

/** Test my KickC Grammar */
public class main {
   public static void main(String [] args) throws IOException {
      CharStream input = CharStreams.fromFileName("src/dk/camelot64/kickc/test/test.kc");
      System.out.println(input.toString());
      KickCLexer lexer = new KickCLexer(input);
      KickCParser parser = new KickCParser(new CommonTokenStream(lexer));
      parser.setBuildParseTree(true);
      KickCParser.FileContext file = parser.file();
      PassGenerateStatementSequence passGenerateStatementSequence = new PassGenerateStatementSequence();
      passGenerateStatementSequence.generate(file);
      StatementSequence statementSequence = passGenerateStatementSequence.getSequence();
      SymbolTable symbolTable = passGenerateStatementSequence.getSymbols();
      new PassTypeInference().inferTypes(statementSequence, symbolTable);
      PassGenerateControlFlowGraph passGenerateControlFlowGraph = new PassGenerateControlFlowGraph(symbolTable);
      ControlFlowGraph controlFlowGraph = passGenerateControlFlowGraph.generate(statementSequence);
      PassCullEmptyBlocks passCullEmptyBlocks = new PassCullEmptyBlocks(symbolTable, controlFlowGraph);
      passCullEmptyBlocks.cull();
      PassGenerateSingleStaticAssignmentForm passGenerateSingleStaticAssignmentForm = new PassGenerateSingleStaticAssignmentForm(
            symbolTable, controlFlowGraph);
      passGenerateSingleStaticAssignmentForm.generate();
      PassConstantPropagation passConstantPropagation = new PassConstantPropagation(symbolTable, controlFlowGraph);
      passConstantPropagation.propagateConstants();
      PassAliasElimination passAliasElimination = new PassAliasElimination(symbolTable, controlFlowGraph);
      passAliasElimination.eliminate();
      PassRedundantPhiElimination passRedundantPhiElimination = new PassRedundantPhiElimination(symbolTable, controlFlowGraph);
      passRedundantPhiElimination.eliminate();
      PassCullEmptyBlocks passCullEmptyBlocks2 = new PassCullEmptyBlocks(symbolTable, controlFlowGraph);
      passCullEmptyBlocks2.cull();
      System.out.println("SYMBOLS");
      System.out.println(symbolTable.toString());
      System.out.println("PROGRAM");
      System.out.println(statementSequence.toString());
      System.out.println("CONTROL FLOW GRAPH");
      System.out.println(controlFlowGraph.toString());
   }

}
