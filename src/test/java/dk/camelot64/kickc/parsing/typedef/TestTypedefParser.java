package dk.camelot64.kickc.parsing.typedef;

import dk.camelot64.kickc.model.CompileError;
import org.antlr.v4.runtime.*;
import org.junit.jupiter.api.Test;

import java.util.ArrayList;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;

public class TestTypedefParser {

   @Test
   public void testExprParser() {

      List<String> typedefs = new ArrayList<>();

      // a & b are not types - resolving to values
      assertEquals("and(val:a,val:b);", parseExprTypedef("a&b;"));
      // a & b are not types - resolving to values even with added parenthesis (looking like a cast)
      assertEquals("and((val:a),val:b);", parseExprTypedef("(a)&b;"));
      // char is a simple type - resolving to cast of simple type
      assertEquals("cast(simpletype:char,addressof(val:b));", parseExprTypedef("(char)&b;"));
      // T is typedeffed - so this should resolve to a cast of typedef
      assertEquals("typedef(simpletype:char,T);cast(typedef:T,addressof(val:b));", parseExprTypedef("typedef char T; (T)&b;"));
      // T is not typedeffed - so this should resolve to an AND
      assertEquals("typedef(simpletype:char,V);and((val:T),val:b);", parseExprTypedef("typedef char V; (T)&b;"));
   }

   /**
    * Parse a Typedef expression and return the resulting syntax tree
    *
    * @param expr The Typedef expression to parse
    * @return The parse-tree in string form
    */
   private String parseExprTypedef(String expr) {
      final CharStream fileStream = CharStreams.fromString(expr);
      // typedefs shared between lexer and parser
      List<String> typedefs = new ArrayList<>();
      TypedefLexer lexer = new TypedefLexer(fileStream, typedefs);
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
      CommonTokenStream tokenStream = new CommonTokenStream(lexer);
      TypedefParser parser = new TypedefParser(tokenStream, typedefs);
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

      TypedefPrinter printVisitor = new TypedefPrinter();
      printVisitor.visit(parser.stmtSeq());
      return printVisitor.getOut().toString();
   }

   private static class TypedefPrinter extends TypedefBaseVisitor<Object> {

      StringBuilder out = new StringBuilder();

      public StringBuilder getOut() {
         return out;
      }

      @Override
      public Object visitStmtSeq(TypedefParser.StmtSeqContext ctx) {
         for(TypedefParser.StmtContext stmtContext : ctx.stmt()) {
            this.visit(stmtContext);
            out.append(";");
         }
         return null;
      }

      @Override
      public Object visitStmtTypeDef(TypedefParser.StmtTypeDefContext ctx) {
         out.append("typedef(");
         this.visit(ctx.typeName());
         out.append(",");
         out.append(ctx.IDENTIFIER().getText());
         out.append(")");
         return null;
      }

      @Override
      public Object visitStmtExpr(TypedefParser.StmtExprContext ctx) {
         this.visit(ctx.expr());
         return null;
      }

      @Override
      public Object visitExprValueName(TypedefParser.ExprValueNameContext ctx) {
         out.append("val:").append(ctx.getText());
         return null;
      }

      @Override
      public Object visitExprCast(TypedefParser.ExprCastContext ctx) {
         out.append("cast(");
         this.visit(ctx.typeName());
         out.append(",");
         this.visit(ctx.expr());
         out.append(")");
         return null;
      }

      @Override
      public Object visitExprAnd(TypedefParser.ExprAndContext ctx) {
         out.append("and(");
         this.visit(ctx.expr(0));
         out.append(",");
         this.visit(ctx.expr(1));
         out.append(")");
         return null;
      }

      @Override
      public Object visitExprAddressOf(TypedefParser.ExprAddressOfContext ctx) {
         out.append("addressof(");
         this.visit(ctx.expr());
         out.append(")");
         return null;
      }

      @Override
      public Object visitExprParenthesis(TypedefParser.ExprParenthesisContext ctx) {
         out.append("(");
         this.visit(ctx.expr());
         out.append(")");
         return null;
      }

      @Override
      public Object visitTypeNameSimple(TypedefParser.TypeNameSimpleContext ctx) {
         out.append("simpletype:").append(ctx.SIMPLETYPE().getText());
         return null;
      }

      @Override
      public Object visitTypeNameTypedef(TypedefParser.TypeNameTypedefContext ctx) {
         out.append("typedef:").append(ctx.getText());
         return null;
      }

   }
}
