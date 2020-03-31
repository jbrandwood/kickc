package dk.camelot64.kickc.parsing.macros;

import dk.camelot64.kickc.model.CompileError;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.misc.Pair;
import org.junit.Test;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.Map;

import static org.junit.Assert.assertEquals;


public class TestMacrosParser {

   /**
    * Test some parsing without macros
    */
   @Test
   public void testParserSimple() {
      // Simple addition
      assertEquals("+(name:a,num:7);", parse("a+7;"));
      // Addition & multiplication
      assertEquals("+(name:a,*(name:b,name:c));", parse("a+b*c;"));
      // Addition and a cast
      assertEquals("+(cast(char,name:b),num:1);", parse("(char)b+1;"));
   }

   /**
    * Test parsing with simple defines
    */
   @Test
   public void testParserDefine() {
      // A simple unused define
      assertEquals("+(name:b,num:1);*(name:c,num:2);", parse("#define A a\nb+1;\nc*2;\n"));
      // A simple used define
      assertEquals("+(*(name:axe,num:2),name:axe);", parse("#define A axe\nA*2+A;"));
      // A define using a special token class
      assertEquals("+(name:axe,num:1);", parse("#define A axe\n#define B +\nA B 1;"));
   }

   /**
    * Parse a program with macros and return the resulting syntax tree
    *
    * @param program The program parse
    * @return The parse-tree in string form
    */
   private String parse(String program) {
      final CharStream fileStream = CharStreams.fromString(program);
      // typedefs shared between lexer and parser
      MacrosLexer lexer = new MacrosLexer(fileStream);
      lexer.addErrorListener(new BaseErrorListener() {
         @Override
         public void syntaxError(
               Recognizer<?, ?> recognizer,
               Object offendingSymbol,
               int line,
               int charPositionInLine,
               String msg,
               RecognitionException e) {
            throw new CompileError("Error parsing  file " + fileStream.getSourceName() + "\n - Line: " + line + "\n - Message: " + msg);
         }
      });

      Map<String, Token> macros = new LinkedHashMap<>();
      final ArrayList<Token> finalTokens = new ArrayList<>();
      Token token = lexer.nextToken();
      while(token.getType() != Token.EOF) {
         if(token.getType() == MacrosLexer.DEFINE) {
            // Define a new macro
            final Token name = lexer.nextToken();
            // TODO: Gobble tokens until newline
            final Token value = lexer.nextToken();
            //System.out.println("Defining " + name.getText() + " to " + value.getText());
            macros.put(name.getText(), value);
         } else if(token.getType()==MacrosLexer.IDENTIFIER && macros.containsKey(token.getText())){
            // Unfold a macro
            final CommonToken newToken = new CommonToken(token);
            final Token unfold = macros.get(token.getText());
            newToken.setText(unfold.getText());
            newToken.setType(unfold.getType());
            newToken.setChannel(unfold.getChannel());
            finalTokens.add(newToken);
         } else {
            finalTokens.add(token);
         }
         token = lexer.nextToken();
      }

      MacrosParser parser = new MacrosParser(new BufferedTokenStream(new ListTokenSource(finalTokens)));
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
            throw new CompileError("Error parsing  file " + fileStream.getSourceName() + "\n - Line: " + line + "\n - Message: " + msg);
         }
      });

      MacrosPrinter printVisitor = new MacrosPrinter();
      printVisitor.visit(parser.stmtSeq());
      return printVisitor.getOut().toString();
   }

   private static class MacrosPrinter extends MacrosBaseVisitor<Object> {

      StringBuilder out = new StringBuilder();

      public StringBuilder getOut() {
         return out;
      }

      @Override
      public Object visitStmtSeq(MacrosParser.StmtSeqContext ctx) {
         for(MacrosParser.StmtContext stmtContext : ctx.stmt()) {
            this.visit(stmtContext);
            out.append(";");
         }
         return null;
      }

      @Override
      public Object visitStmtExpr(MacrosParser.StmtExprContext ctx) {
         this.visit(ctx.expr());
         return null;
      }

      @Override
      public Object visitExprName(MacrosParser.ExprNameContext ctx) {
         out.append("name:").append(ctx.getText());
         return null;
      }

      @Override
      public Object visitExprNumber(MacrosParser.ExprNumberContext ctx) {
         return out.append("num:").append(ctx.getText());
      }

      @Override
      public Object visitExprCast(MacrosParser.ExprCastContext ctx) {
         out.append("cast(");
         out.append(ctx.SIMPLETYPE().getText());
         out.append(",");
         this.visit(ctx.expr());
         out.append(")");
         return null;
      }

      @Override
      public Object visitExprBinary(MacrosParser.ExprBinaryContext ctx) {
         String fct = ctx.getChild(1).getText();
         out.append(fct).append("(");
         this.visit(ctx.expr(0));
         out.append(",");
         this.visit(ctx.expr(1));
         out.append(")");
         return null;
      }


      @Override
      public Object visitExprPar(MacrosParser.ExprParContext ctx) {
         out.append("(");
         this.visit(ctx.expr());
         out.append(")");
         return null;
      }

   }
}
