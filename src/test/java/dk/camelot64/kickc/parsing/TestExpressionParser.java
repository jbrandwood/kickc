package dk.camelot64.kickc.parsing;

import dk.camelot64.kickc.parser.*;
import junit.framework.TestCase;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CodePointCharStream;
import org.antlr.v4.runtime.tree.TerminalNode;
import org.junit.Test;

import java.io.IOException;
import java.net.URISyntaxException;

public class TestExpressionParser {

   /**
    * Test the ExpressionParser
    */
   @Test
   public void testExpressionParser() {
      assertExpression("1", "1");
      assertExpression("1+1", "+(1,1)");
      assertExpression("1+1*-2", "+(1,*(1,-(2)))");
      assertExpression("(1+1)*2", "*([+(1,1)],2)");
      assertExpression("FIELDS*2<MAX", "<(*(FIELDS,2),MAX)");
   }

   private void assertExpression(String expr, String expected) {
      CodePointCharStream fragmentCharStream = CharStreams.fromString(expr);
      CParser cParser = new CParser(null);
      KickCLexer kickCLexer = new KickCLexer(fragmentCharStream, cParser);
      KickCParser.ExprContext exprContext = ExpressionParser.parseExpression(kickCLexer);
      final KickCParserBaseVisitor<String> exprVisitor = new ExprPrinter();
      final String exprOut = exprVisitor.visit(exprContext);
      TestCase.assertEquals("Expression output does not match ", expected, exprOut);
   }


   /** Prints the expression. */
   private static class ExprPrinter extends KickCParserBaseVisitor<String> {

      @Override
      public String visitExprBinary(KickCParser.ExprBinaryContext ctx) {
         final String left = this.visit(ctx.expr(0));
         String op = ((TerminalNode) ctx.getChild(1)).getSymbol().getText();
         final String right = this.visit(ctx.expr(1));
         return op+"("+left+","+right+")";
      }

      @Override
      public String visitExprUnary(KickCParser.ExprUnaryContext ctx) {
         String op = ((TerminalNode) ctx.getChild(0)).getSymbol().getText();
         final String right = this.visit(ctx.expr());
         return op+"("+right+")";
      }

      @Override
      public String visitExprPar(KickCParser.ExprParContext ctx) {
         final String sub = this.visit(ctx.commaExpr());
         return "["+sub+"]";
      }

      @Override
      public String visitExprNumber(KickCParser.ExprNumberContext ctx) {
         return ctx.NUMBER().getText();
      }

      @Override
      public String visitExprId(KickCParser.ExprIdContext ctx) {
         return ctx.NAME().getText();
      }
   }

}
