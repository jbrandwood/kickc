package dk.camelot64.kickc.parsing.macros;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.parser.CParser;
import dk.camelot64.kickc.parser.KickCParser;
import dk.camelot64.kickc.parser.KickCParserBaseVisitor;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CodePointCharStream;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Test the C preprocessor
 */
public class TestPreprocessor {

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
      // A minimal used define
      assertEquals("name:a;", parse("#define A a\nA;"));
      // A simple used define
      assertEquals("+(*(name:axe,num:2),name:axe);", parse("#define A axe\nA*2+A;"));
      // A define using a special token class
      assertEquals("+(name:a,num:1);", parse("#define A a\n#define B +\n\n#define C 1\nA B C;"));
      // A define with two tokens
      assertEquals("+(name:a,num:1);", parse("#define A a+\nA 1;"));
   }

   /**
    * Test empty define
    */
   @Test
   public void testEmptyDefine() {
      // A define with empty body
      assertEquals("name:b;", parse("#define A\nb;"));
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
    * Test define and undef
    */
   @Test
   public void testUndef() {
      // An simple use of #undef
      assertEquals("name:a;name:A;", parse("#define A a\nA;\n#undef A\nA;"));
      // #undef a macro that has not been defined
      assertEquals("name:a;", parse("#undef A\na;"));
   }

   /**
    * Test #ifdef, #ifndef, #else and #endif
    */
   @Test
   public void testIfdef() {
      // Output generated by #ifdef
      assertEquals("name:x;name:y;", parse("#define A a\n#ifdef A\nx;\n#endif\ny;"));
      // Output not generated by #ifdef
      assertEquals("name:y;", parse("#ifdef A\nx;\n#endif\ny;"));
      // Output not generated by #ifdef and generated by #else
      assertEquals("name:x2;name:y;", parse("#ifdef A\nx1;\n#else\nx2;\n#endif\ny;"));
      // Output generated by #ifdef and not by #else
      assertEquals("name:x1;name:y;", parse("#define A a\n#ifdef A\nx1;\n#else\nx2;\n#endif\ny;"));
      // Nested #ifdefs with #else
      assertEquals("name:x3;name:y;", parse("#define B\n#ifdef A\n#ifdef B\nx1;\n#else\nx2;#endif\n#else\n#ifdef B\nx3;\n#else\nx4;#endif\n#endif\ny; "));
      // Output not generated by #ifndef and generated by #else
      assertEquals("name:x1;name:y;", parse("#ifndef A\nx1;\n#else\nx2;\n#endif\ny;"));
      // Output generated by #ifndef and not by #else
      assertEquals("name:x2;name:y;", parse("#define A a\n#ifndef A\nx1;\n#else\nx2;\n#endif\ny;"));
   }

   /**
    * Test #if
    */
   @Test
   public void testIf() {
      // Output not generated by #if
      assertEquals("name:y;", parse("#if 0\nx;\n#endif\ny;"));
      // Output generated by #if
      assertEquals("name:x;name:y;", parse("#define A 7\n#if 7\nx;\n#endif\ny;"));
      // Output generated by #if using a sub-define
      assertEquals("name:x;name:y;", parse("#define A 7\n#if A\nx;\n#endif\ny;"));
      // Output not generated by #if using an undefined symbol
      assertEquals("name:y;", parse("#if A\nx;\n#endif\ny;"));
      // Output not generated by #if using an symbol==0
      assertEquals("name:y;", parse("#define A 0\n#if A\nx;\n#endif\ny;"));
      // Output generated by #if using an expression
      assertEquals("name:x;name:y;", parse("#define A 7\n#if A==7\nx;\n#endif\ny;"));
      // Output not generated by #if using an expression
      assertEquals("name:y;", parse("#define A 7\n#if A==6\nx;\n#endif\ny;"));
      // Output generated by #if using an expression
      assertEquals("name:x;name:y;", parse("#define A 7\n#define B 8\n#if A<B\nx;\n#endif\ny;"));
      // Output not generated by #if using an expression
      assertEquals("name:y;", parse("#define A 7\n#define B 8\n#if A>B\nx;\n#endif\ny;"));
      // Output generated by #if using an expression with a parenthesis
      assertEquals("name:x;name:y;", parse("#define A 7\n#define B 8\n#if (A<B)\nx;\n#endif\ny;"));
      // Output generated by #if using an expression with a few parenthesis
      assertEquals("name:x;name:y;", parse("#define A 7\n#define B 8\n#if ((A)<(B))\nx;\n#endif\ny;"));
      // Output not generated by #if using an expression with a few parenthesis
      assertEquals("name:y;", parse("#define A 7\n#define B 8\n#if ((A)>(B))\nx;\n#endif\ny;"));
      // Output generated by #if using a unary expression
      assertEquals("name:x;name:y;", parse("#define A -10\n#define B 8\n#if A<-B\nx;\n#endif\ny;"));
      // Output not generated by #if using a unary expression
      assertEquals("name:y;", parse("#define A 7\n#define B 8\n#if !(A<B)\nx;\n#endif\ny;"));
      // Output not generated by #if using an expression with an undefined symbol
      assertEquals("name:y;", parse("#define A 7\n#if A<B\nx;\n#endif\ny;"));
      // Output generated by #if using defined operator
      assertEquals("name:x;name:y;", parse("#define A X\n#if defined A\nx;\n#endif\ny;"));
      // Output not generated by #if using defined operator
      assertEquals("name:y;", parse("#if defined A\nx;\n#endif\ny;"));
      // Output generated by #elif
      assertEquals("name:y;name:w;", parse("#if 0\nx;\n#elif 1\ny;\n#elif 1\nz;\n#else\nq;\n#endif\nw;"));
      // Output generated by #if using defined and || operator
      assertEquals("name:x;name:y;", parse("#define A X\n#if defined(A) || defined(B)\nx;\n#endif\ny;"));
   }

   /**
    * Test #define with wrong syntax
    */
   @Test
   public void testErrors() {
      // Declared parameters are not names
      assertError("#define f(x,1) x", "#define declared parameter not a NAME.", true);
      // Declared parameter list ends with comma
      assertError("#define f(x,y,) x", "#define declared parameter list ends with COMMA.", true);
      // Number of parameters not matching
      assertError("#define f(x,y) x+y\nf(7);", "Wrong number of macro parameters. Expected 2 was 1", true);
   }

   /**
    * Test define with parameters
    */
   @Test
   public void testDefineParams() {
      // A simple define with an empty parameter
      assertEquals("+(name:a,num:1);", parse("#define A() a+1\nA();"));
      // A simple define with one parameter
      assertEquals("+(name:b,num:1);", parse("#define A(a) a+1\nA(b);"));
      // A simple define with one parameter used twice
      assertEquals("+(name:b,num:1);+(name:c,num:1);", parse("#define A(a) a+1\nA(b);A(c);"));
      // A simple define with two parameters
      assertEquals("+(num:1,name:x);", parse("#define A(a,b) a+b\nA(1,x);"));
      // A nested call
      assertEquals("+(+(name:x,num:1),num:1);", parse("#define A(a) a+1\nA(A(x));"));
      // A double nested call
      assertEquals("+(+(+(name:x,num:1),num:1),num:1);", parse("#define A(a) a+1\nA(A(A(x)));"));
      // A nested call for a 2-parameter macro
      assertEquals("+(+(+(name:x,name:y),name:z),name:w);", parse("#define A(a,b) a+b\nA(A(x,y),A(z,w));"));
      // A simple define with one parameter - used without the parenthesis
      assertEquals("+(name:A,name:b);", parse("#define A(a) a+1\nA+b;"));
   }

   /**
    * Test define with/without whitespace
    */
   @Test
   public void testDefineWhitespace() {
      // A simple define with one parameter
      assertEquals("(name:b);", parse("#define A(a) (a) \nA(b);"));
      // A simple define without a parameter - but where the body starts with a parenthesis
      assertEquals("call(call((name:a),name:a),name:b);", parse("#define A (a) (a) \nA(b);"));
      // A real-life define without a parameter - but where the body starts with a parenthesis
      assertEquals("(&(call(name:PEEK,+(name:VIC_BASE,num:0x31)),num:128));", parse("#define IS_H640 (PEEK(VIC_BASE + 0x31) & 128)\nIS_H640;"));
   }

   private void assertError(String program, String expectError, boolean expectLineNumber) {
      try {
         parse(program);
      } catch(CompileError e) {
         System.out.println("Got error: " + e.getMessage());
         // expecting error!
         assertTrue(e.getMessage().contains(expectError), "Error message expected  '" + expectError + "' - was:" + e.getMessage());
         if (expectLineNumber) {
            // expecting a source for the error, so it may be related back to a file/line
            assertNotNull(e.getSource());
            assertNotNull(e.getSource().getLineNumber());
         }
         return;
      }
      fail("Expected compile error.");
   }

   /**
    * Parse a program with macros and return the resulting syntax tree
    *
    * @param program The program parse
    * @return The parse-tree in string form
    */
   private String parse(String program) {
      CodePointCharStream charStream = CharStreams.fromString(program);
      CParser cParser = new CParser(null);
      cParser.addSourceFirst(cParser.makeLexer(charStream));
      KickCParser.StmtSeqContext stmtSeqContext = cParser.getParser().stmtSeq();
      ProgramPrinter printVisitor = new ProgramPrinter();
      printVisitor.visit(stmtSeqContext);
      return printVisitor.getOut().toString();
   }

   private static class ProgramPrinter extends KickCParserBaseVisitor<Object> {

      StringBuilder out = new StringBuilder();

      StringBuilder getOut() {
         return out;
      }

      @Override
      public Object visitStmtSeq(KickCParser.StmtSeqContext ctx) {
         for(KickCParser.StmtContext stmtContext : ctx.stmt()) {
            this.visit(stmtContext);
            out.append(";");
         }
         return null;
      }

      @Override
      public Object visitExprId(KickCParser.ExprIdContext ctx) {
         out.append("name:").append(ctx.NAME().getText());
         return null;
      }

      @Override
      public Object visitExprNumber(KickCParser.ExprNumberContext ctx) {
         return out.append("num:").append(ctx.NUMBER().getText());
      }

      @Override
      public Object visitExprCast(KickCParser.ExprCastContext ctx) {
         out.append("cast(");
         out.append(ctx.typeName().getText());
         out.append(",");
         this.visit(ctx.expr());
         out.append(")");
         return null;
      }

      @Override
      public Object visitExprBinary(KickCParser.ExprBinaryContext ctx) {
         String fct = ctx.getChild(1).getText();
         out.append(fct).append("(");
         this.visit(ctx.expr(0));
         out.append(",");
         this.visit(ctx.expr(1));
         out.append(")");
         return null;
      }

      @Override
      public Object visitExprPar(KickCParser.ExprParContext ctx) {
         out.append("(");
         this.visit(ctx.commaExpr());
         out.append(")");
         return null;
      }

      @Override
      public Object visitExprCall(KickCParser.ExprCallContext ctx) {
         out.append("call(");
         this.visit(ctx.expr());
         boolean isFirst = true;
         for(KickCParser.ExprContext paramCtx : ctx.parameterList().expr()) {
            out.append(",");
            this.visit(paramCtx);
         }
         out.append(")");
         return null;
      }
   }
}
