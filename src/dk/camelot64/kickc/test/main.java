package dk.camelot64.kickc.test;

import dk.camelot64.kickc.parser.KickCLexer;
import dk.camelot64.kickc.parser.KickCParser;
import dk.camelot64.kickc.ssa.GenerateSSA;
import dk.camelot64.kickc.ssa.SSAVariableManager;
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
      KickCParser.ExprContext expr = parser.expr();
      GenerateSSA ev = new GenerateSSA(new SSAVariableManager());
      Object result = ev.visit(expr);
   }

}
