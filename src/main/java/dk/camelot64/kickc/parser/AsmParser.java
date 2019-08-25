package dk.camelot64.kickc.parser;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.statements.StatementSource;
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
      CParser cParser = new CParser(null);
      KickCLexer kickCLexer = new KickCLexer(fragmentCharStream, cParser);
      kickCLexer.pushMode(KickCLexer.ASM_MODE);
      KickCParser kickCParser = new KickCParser(new CommonTokenStream(kickCLexer), cParser);
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
