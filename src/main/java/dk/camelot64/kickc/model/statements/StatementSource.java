package dk.camelot64.kickc.model.statements;

import dk.camelot64.kickc.model.InternalError;
import dk.camelot64.kickc.parser.KickCParser;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.misc.Interval;
import org.antlr.v4.runtime.tree.ParseTree;
import org.antlr.v4.runtime.tree.TerminalNode;

/** Contains information about the source of a program statement */
public class StatementSource {

   private Token tokenStart;

   private Token tokenStop;

   public StatementSource(ParserRuleContext context) {
      this.tokenStart = context.getStart();
      this.tokenStop = context.getStop();
   }

   public StatementSource(ParseTree start, ParseTree stop) {
      this.tokenStart = getToken(start, true);
      this.tokenStop = getToken(stop, false);
   }

   public static Token getToken(ParseTree node, boolean start) {
      Token token;
      if(node==null) {
         return null;
      } else if(node instanceof TerminalNode) {
         token = ((TerminalNode) node).getSymbol();
      } else if(node instanceof ParserRuleContext) {
         if(start) {
            token = ((ParserRuleContext) node).getStart();
         } else {
            token = ((ParserRuleContext) node).getStop();
         }
      } else {
         throw new InternalError("Unhandled parse tree node " + node);
      }
      return token;
   }

   public static StatementSource forRanged(KickCParser.ForRangeContext context) {
      ParseTree nodeStart = context.getParent();
      ParseTree nodeStop = context.getParent().getChild(context.getParent().getChildCount() - 2);
      return new StatementSource(nodeStart, nodeStop);
   }

   public static StatementSource forClassic(KickCParser.ForClassicContext context) {
      ParseTree nodeStart = context.getParent();
      ParseTree nodeStop = context.getParent().getChild(context.getParent().getChildCount() - 2);
      return new StatementSource(nodeStart, nodeStop);
   }

   public static StatementSource ifThen(KickCParser.StmtIfElseContext ctx) {
      ParseTree nodeStart = ctx;
      if(ctx.stmt(1)==null) {
         // No else part
         ParseTree nodeStop = ctx.getChild(ctx.getChildCount() - 2);
         return new StatementSource(nodeStart, nodeStop);
      } else {
         // Has an else part
         ParseTree nodeStop = ctx.getChild(ctx.getChildCount() - 4);
         return new StatementSource(nodeStart, nodeStop);
      }
   }

   public static StatementSource ifElse(KickCParser.StmtIfElseContext ctx) {
      ParseTree nodeStart = ctx.getChild(ctx.getChildCount() - 3);
      ParseTree nodeStop = ctx.getChild(ctx.getChildCount() - 3);
      return new StatementSource(nodeStart, nodeStop);
   }

   public static StatementSource doWhile(KickCParser.StmtDoWhileContext context) {
      ParseTree nodeStart = context.getChild(2);
      ParseTree nodeStop = context.getChild(context.getChildCount() - 2);
      return new StatementSource(nodeStart, nodeStop);
   }

   public static StatementSource whileDo(KickCParser.StmtWhileContext ctx) {
      ParseTree nodeStart = ctx;
      ParseTree nodeStop = ctx.getChild(ctx.getChildCount() - 2);
      return new StatementSource(nodeStart, nodeStop);
   }

   public static StatementSource procedureEnd(KickCParser.DeclFunctionContext ctx) {
      ParseTree nodeStart = ctx.getChild(ctx.getChildCount()-1);
      ParseTree nodeStop = ctx;
      return new StatementSource(nodeStart, nodeStop);
   }

   public static StatementSource procedureBegin(KickCParser.DeclFunctionContext ctx) {
      ParseTree nodeStart = ctx;
      ParseTree nodeStop = ctx.getChild(ctx.getChildCount()-4);
      return new StatementSource(nodeStart, nodeStop);
   }

   public static StatementSource asm(KickCParser.StmtAsmContext ctx) {
      ParseTree nodeStart = ctx.getChild(0);
      ParseTree nodeStop = ctx.getChild(0);
      return new StatementSource(nodeStart, nodeStop);
   }

   public static StatementSource kickAsm(KickCParser.DeclKasmContext ctx) {
      ParseTree nodeStart = ctx.getChild(0);
      ParseTree nodeStop = ctx.getChild(0);
      return new StatementSource(nodeStart, nodeStop);
   }

   /**
    * Get the underlying source token interval
    * @return The interval
    */
   private Interval getInterval() {
      return new Interval(tokenStart.getStartIndex(), tokenStop.getStopIndex());
   }

   /**
    * Determines if this source contains another source
    * @param other The other source to examine
    * @return true if this source contains the other source
    */
   public boolean contains(StatementSource other) {
      if(other==null)
         return false;
      return getInterval().properlyContains(other.getInterval());
   }

   public String getFile() {
      if(tokenStart != null) {
         CharStream stream = tokenStart.getInputStream();
         return stream.getSourceName();
      }
      return null;
   }

   public Integer getLineNumber() {
      if(tokenStart != null) {
         return tokenStart.getLine();
      }
      return null;
   }

   public String getCode() {
      if(tokenStart != null) {
         CharStream stream = tokenStart.getInputStream();
         Interval interval = getInterval();
         String codeText = stream.getText(interval);
         return codeText;
      }
      return null;
   }


   @Override
   public String toString() {
      if(tokenStart != null) {
         CharStream stream = tokenStart.getInputStream();
         Interval interval = getInterval();
         return "File " + stream.getSourceName() + "\nLine " + tokenStart.getLine() + "\n" + stream.getText(interval);
      } else {
         return "";
      }
   }
}
