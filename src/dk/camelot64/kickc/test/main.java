package dk.camelot64.kickc.test;

import dk.camelot64.kickc.icl.ControlFlowGraph;
import dk.camelot64.kickc.icl.PassGenerateControlFlowGraph;
import dk.camelot64.kickc.parser.KickCLexer;
import dk.camelot64.kickc.parser.KickCParser;
import dk.camelot64.kickc.icl.PassGenerateStatementSequence;
import dk.camelot64.kickc.icl.PassTypeInference;
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
      passGenerateStatementSequence.visit(file);
      new PassTypeInference().inferTypes(passGenerateStatementSequence.getSequence(), passGenerateStatementSequence.getSymbols());
      PassGenerateControlFlowGraph passGenerateControlFlowGraph = new PassGenerateControlFlowGraph(passGenerateStatementSequence.getSymbols());
      ControlFlowGraph controlFlowGraph = passGenerateControlFlowGraph.generate(passGenerateStatementSequence.getSequence());
      System.out.println("SYMBOLS");
      System.out.println(passGenerateStatementSequence.getSymbols().toString());
      System.out.println("PROGRAM");
      System.out.println(passGenerateStatementSequence.getSequence().toString());
      System.out.println("CONTROL FLOW GRAPH");
      System.out.println(controlFlowGraph.toString());

   }

}
