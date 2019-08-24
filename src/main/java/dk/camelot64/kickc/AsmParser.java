package dk.camelot64.kickc;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.statements.StatementSource;
import dk.camelot64.kickc.parser.KickCLexer;
import dk.camelot64.kickc.parser.KickCParser;
import dk.camelot64.kickc.parser.ParserState;
import org.antlr.v4.runtime.*;

public class AsmParser {

   /**
    * Parse assembler code
    * @param body The assembler to parse
    * @param source Information about the source of the ASM
    * @return The parser assembler
    */
   public static KickCParser.AsmLinesContext parseAsm(String body, StatementSource source) {
      CodePointCharStream fragmentCharStream = CharStreams.fromString(body);
      ParserState parserState = new ParserState();
      KickCLexer kickCLexer = new KickCLexer(fragmentCharStream);
      KickCParser kickCParser = new KickCParser(new CommonTokenStream(kickCLexer), kickCLexer);
      kickCParser.addErrorListener(new BaseErrorListener() {
         @Override
         public void syntaxError(Recognizer<?, ?> recognizer, Object offendingSymbol, int line, int charPositionInLine, String msg, RecognitionException e) {
            StatementSource subSource =
                  new StatementSource(source.getFileName(), source.getLineNumber() + line, source.getCode(), source.getStartIndex(), source.getStopIndex());

            throw new CompileError("Error parsing assembler. " + msg, subSource);
         }
      });
      kickCParser.setBuildParseTree(true);
      return kickCParser.asmFile().asmLines();
   }

}
