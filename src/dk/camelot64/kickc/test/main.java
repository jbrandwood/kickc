package dk.camelot64.kickc.test;

import dk.camelot64.kickc.parser.KickCLexer;
import dk.camelot64.kickc.parser.KickCParser;
import dk.camelot64.kickc.ssa.GenerateSSA;
import dk.camelot64.kickc.ssa.PassTypeInference;
import dk.camelot64.kickc.ssa.SSASequence;
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
      GenerateSSA ev = new GenerateSSA();
      ev.visit(file);

      PassTypeInference passTypeInference = new PassTypeInference();
      passTypeInference.inferTypes(ev.getSequence(), ev.getSymbols());

      System.out.println("PROGRAM");
      System.out.println(ev.getSequence().toString());
      System.out.println("SYMBOLS");
      System.out.println(ev.getSymbols().toString());
   }

}
