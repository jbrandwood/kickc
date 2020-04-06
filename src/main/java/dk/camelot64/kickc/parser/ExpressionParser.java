package dk.camelot64.kickc.parser;

import dk.camelot64.kickc.model.CompileError;
import org.antlr.v4.runtime.*;


/**
 * Parser for C-expressions.
 * <p>
 * Used by #if in the preprocessor
 */
public class ExpressionParser {

   /**
    * Parse an expression
    *
    * @param tokenSource The tokens to parse
    * @return The parsed expression
    */
   public static KickCParser.ExprContext parseExpression(TokenSource tokenSource) {
      CParser cParser = new CParser(null);
      KickCParser kickCParser = new KickCParser(new CommonTokenStream(tokenSource), cParser);
      kickCParser.addErrorListener(new BaseErrorListener() {
         @Override
         public void syntaxError(Recognizer<?, ?> recognizer, Object offendingSymbol, int line, int charPositionInLine, String msg, RecognitionException e) {
            //StatementSource subSource =
            //      new StatementSource(source.getFileName(), source.getLineNumber() + line, source.getCode(), source.getStartIndex(), source.getStopIndex());
            throw new CompileError("Error parsing expression " + msg);
         }
      });
      kickCParser.setBuildParseTree(true);
      return kickCParser.expr();
   }

}
