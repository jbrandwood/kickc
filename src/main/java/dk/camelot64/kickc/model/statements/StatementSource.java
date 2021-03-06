package dk.camelot64.kickc.model.statements;

import dk.camelot64.kickc.model.InternalError;
import dk.camelot64.kickc.parser.KickCParser;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.misc.Interval;
import org.antlr.v4.runtime.tree.ParseTree;
import org.antlr.v4.runtime.tree.TerminalNode;

import java.nio.file.Path;
import java.nio.file.Paths;

/** Contains information about the source of a program statement */
public class StatementSource {

   /** The file name of the file containing the source. */
   private String fileName;
   /** The line number of the start of the source. */
   private Integer lineNumber;
   /** The char position on the line of the start of the source. */
   private Integer charPosInLine;
   /** The source code. */
   private String code;
   /** The index of the first char of the source in the file. */
   private int startIndex;
   /** The index of the last char of the source in the file. */
   private int stopIndex;

   public StatementSource(String fileName, Integer lineNumber, Integer charPosInLine, String code, int startIndex, int stopIndex) {
      this.fileName = fileName;
      this.lineNumber = lineNumber;
      this.charPosInLine = charPosInLine;
      this.code = code;
      this.startIndex = startIndex;
      this.stopIndex = stopIndex;
   }

   /** An empty statement source. */
   public static StatementSource NONE = new StatementSource(null, null, null, null, -1, -1);

   public StatementSource(Token tokenStart, Token tokenStop) {
      if(tokenStart != null && tokenStart.getStartIndex() >= 0) {
         this.startIndex = tokenStart.getStartIndex();
         CharStream stream = tokenStart.getInputStream();
         this.fileName = stream.getSourceName();
         this.lineNumber = tokenStart.getLine();
         this.charPosInLine = tokenStart.getCharPositionInLine();
         if(tokenStop != null && tokenStop.getStopIndex() >= this.startIndex) {
            this.stopIndex = tokenStop.getStopIndex();
            Interval interval = getInterval();
            this.code = stream.getText(interval);
         }
      }
   }

   public StatementSource(ParserRuleContext context) {
      this(context.getStart(), context.getStop());
   }

   public StatementSource(ParseTree start, ParseTree stop) {
      this(getToken(start, true), getToken(stop, false));
   }

   public static Token getToken(ParseTree node, boolean start) {
      Token token;
      if(node == null) {
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
      if(ctx.stmt(1) == null) {
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

   public static StatementSource switchExpr(KickCParser.StmtSwitchContext ctx) {
      ParseTree nodeStart = ctx;
      ParseTree nodeStop = ctx.getChild(ctx.getChildCount() - 4);
      return new StatementSource(nodeStart, nodeStop);
   }

   public static StatementSource switchCase(KickCParser.SwitchCaseContext ctx) {
      ParseTree nodeStart = ctx;
      ParseTree nodeStop = ctx.getChild(ctx.getChildCount() - 1);
      return new StatementSource(nodeStart, nodeStop);
   }

   public static StatementSource switchDefault(KickCParser.SwitchCasesContext ctx) {
      ParseTree nodeStart = ctx.getChild(ctx.getChildCount() - 2);
      ParseTree nodeStop = ctx.getChild(ctx.getChildCount() - 1);
      return new StatementSource(nodeStart, nodeStop);
   }

   public static StatementSource procedureDecl(KickCParser.DeclFunctionContext ctx) {
      return new StatementSource(ctx.getChild(0), ctx.getChild(1));
   }

   public static StatementSource procedureBegin(KickCParser.DeclFunctionContext ctx) {
      return new StatementSource(ctx.getChild(0), ctx.getChild(2));
   }

   public static StatementSource procedureEnd(KickCParser.DeclFunctionContext ctx) {
      return new StatementSource(ctx.getChild(4), ctx.getChild(4));
   }

   public static StatementSource asm(KickCParser.StmtAsmContext ctx) {
      ParseTree nodeStart = ctx.getChild(0);
      ParseTree nodeStop = ctx.getChild(0);
      return new StatementSource(nodeStart, nodeStop);
   }

   public static StatementSource kickAsm(KickCParser.KasmContentContext ctx) {
      ParseTree nodeStart = ctx.getChild(0);
      ParseTree nodeStop = ctx.getChild(0);
      return new StatementSource(nodeStart, nodeStop);
   }

   /**
    * Get the underlying source token interval
    *
    * @return The interval
    */
   private Interval getInterval() {
      return new Interval(startIndex, stopIndex);
   }

   /**
    * Determines if this source contains another source
    *
    * @param other The other source to examine
    * @return true if this source contains the other source
    */
   public boolean contains(StatementSource other) {
      if(other == null)
         return false;
      return getInterval().properlyContains(other.getInterval());
   }

   public String getFileName() {
      return fileName;
   }

   public Integer getLineNumber() {
      return lineNumber;
   }

   public Integer getCharPosInLine() {
      return charPosInLine;
   }

   public String getCode() {
      return code;
   }

   public int getStartIndex() {
      return startIndex;
   }

   public int getStopIndex() {
      return stopIndex;
   }

   @Override
   public String toString() {
      return format();
   }

   /**
    * Format the statement source in GCC format
    * https://www.gnu.org/prep/standards/html_node/Errors.html
    * <li> sourcefile:lineno:
    * <li> sourcefile:lineno:column:
    *
    * @return The formatted source location
    */
   public String format() {
      if(getFileName() == null)
         return "";
      Path sourcePath = Paths.get(getFileName());
      String relativeFileName = sourcePath.toAbsolutePath().toString();
      if(getCharPosInLine() == null || getCharPosInLine() == 0) {
         // No relevant column idx  - format without
         return String.format("%s:%s:", relativeFileName, getLineNumber());
      } else {
         // Format with column idx
         return String.format("%s:%s:%s:", relativeFileName, getLineNumber(), getCharPosInLine() + 1);
      }
   }

}
