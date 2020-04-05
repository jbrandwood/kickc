package dk.camelot64.kickc.parsing.macros;

import dk.camelot64.kickc.preprocessor.CTokenSourcePreprocessor;
import dk.camelot64.kickc.model.CompileError;
import org.antlr.v4.runtime.*;
import org.junit.Test;

import static org.junit.Assert.assertEquals;

public class TestMacrosParser {

   private int CHANNEL_WHITESPACE = 1;

   /**
    * Test some parsing without macros
    */
   @Test
   public void testParser() {
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
    * Test some simple defines
    */
   @Test
   public void testSimpleDefine() {
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
    * Test define where the body uses another define
    */
   @Test
   public void testDefineSub() {
      // A uses B
      assertEquals("+(*(name:c,num:2),num:1);", parse("#define A B+1\n#define B c*2\nA;"));
      // A uses B uses C
      assertEquals("+(*(name:c,num:2),name:c);", parse("#define A B+C\n#define B C*2\n#define C c\nA;"));
   }

   /**
    * Test define with recursion
    */
   @Test
   public void testDefineRecursion() {
      // A uses A
      assertEquals("+(name:A,num:1);", parse("#define A A+1\nA;"));
      // A uses B uses A
      assertEquals("+(*(name:A,num:2),num:1);+(name:B,*(num:1,num:2));", parse("#define A B+1\n#define B A*2\nA;B;"));
   }

   /**
    * Test define with multi-line body
    */
   @Test
   public void testDefineMultiline() {
      // A simple unused define
      assertEquals("name:a;+(name:b,num:1);", parse("#define A a;\\\nb\nA+1;"));
   }

   /**
    * Test define with parameters
    */
   //@Test
   //public void testDefineParams() {
   //   // A simple unused define
   //   assertEquals("+(name:b,num:1);*(name:c,num:2);", parse("#define A(a) a+1\nA(b)"));
   //}

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

      final CTokenSourcePreprocessor expandedTokenSource = new CTokenSourcePreprocessor(lexer, CHANNEL_WHITESPACE, MacrosLexer.WHITESPACE, MacrosLexer.DEFINE, MacrosLexer.IDENTIFIER, MacrosLexer.PAR_BEGIN, MacrosLexer.PAR_END, MacrosLexer.COMMA, MacrosLexer.DEFINE_CONTINUE);
      MacrosParser parser = new MacrosParser(new CommonTokenStream(expandedTokenSource));
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
