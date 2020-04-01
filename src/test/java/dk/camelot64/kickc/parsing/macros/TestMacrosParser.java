package dk.camelot64.kickc.parsing.macros;

import dk.camelot64.kickc.model.CompileError;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.misc.Pair;
import org.junit.Test;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import static org.junit.Assert.assertEquals;


public class TestMacrosParser {

   public static final int CHANNEL_WHITESPACE = 1;

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
      // Two statements
      assertEquals("+(name:a,name:c);*(name:d,num:2);", parse("a+c;d*2;"));
      // Some whitespace
      assertEquals("+(name:a,name:c);", parse(" \ta + \nc ;"));
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
      assertEquals("+(name:a,num:1);", parse("#define A a\n#define B +\n\n#define C 1\nA B C;"));
      // A define with two tokens
      assertEquals("+(name:a,num:1);", parse("#define A a+\nA 1;"));
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

      Map<String, List<Token>> macros = new LinkedHashMap<>();
      final ArrayList<Token> finalTokens = new ArrayList<>();
      Token token = lexer.nextToken();
      while(token.getType() != Token.EOF) {
         if(token.getType() == MacrosLexer.DEFINE) {
            // Define a new macro - find name
            Token name = lexer.nextToken();
            while(name.getType()==MacrosLexer.WHITESPACE)
               name = lexer.nextToken();
            // Find value by gobbling tokens until the line ends
            final ArrayList<Token> macroValue = new ArrayList<>();
            boolean macroRead = true;
            while(macroRead) {
               final Token value = lexer.nextToken();
               final String text = value.getText();
               if(value.getChannel()== CHANNEL_WHITESPACE && value.getText().contains("\n")) {
                  macroRead = false;
               } else {
                  macroValue.add(value);
               }
            }
            macros.put(name.getText(), macroValue);
         } else if(token.getType()==MacrosLexer.IDENTIFIER && macros.containsKey(token.getText())){
            // Unfold a macro
            final List<Token> macroValue = macros.get(token.getText());
            for(Token macroToken : macroValue) {
               final CommonToken newToken = new CommonToken(token);
               newToken.setText(macroToken.getText());
               newToken.setType(macroToken.getType());
               newToken.setChannel(macroToken.getChannel());
               finalTokens.add(newToken);
            }
         } else {
            finalTokens.add(token);
         }
         token = lexer.nextToken();
      }
      MacrosParser parser = new MacrosParser(new CommonTokenStream(new ListTokenSource(finalTokens)));

      //CommonTokenStream tokenStream = new CommonTokenStream(lexer);
      //MacrosParser parser = new MacrosParser(tokenStream);

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
