package dk.camelot64.kickc.parser;

import dk.camelot64.kickc.SourceLoader;
import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.preprocessor.CPreprocessor;
import org.antlr.v4.runtime.*;

import java.io.File;
import java.io.IOException;
import java.nio.file.Path;
import java.util.*;

/**
 * Parser for C-language files.
 * <p>
 * Handles imports and multiple source files.
 * <p>
 * All state is stored in the {@link dk.camelot64.kickc.model.Program}
 */

public class CParser {

   /** The hidden lexer channel containing whitespace. */
   public static final int CHANNEL_WHITESPACE = 1;
   /** The hidden lexer channel containing comments. */
   public static final int CHANNEL_COMMENTS = 2;

   /** The Program. */
   private Program program;

   /** The (single) parser. */
   private KickCParser parser;

   /** The token stream. */
   private final CommonTokenStream tokenStream;

   /** The token source stack handling import files. */
   private CTokenSource cTokenSource;

   /** The input files that have been parsed. Maps file name to the lexer. */
   private Map<String, CFile> cFiles;

   /** Names of typedefs. Used by lexer to know the difference between normal value IDENTIFIERS and TYPEIDENTIFIERS */
   private List<String> typedefs;

   /** A C-file that has been imported & parsed. */
   public static class CFile {
      /** The source file currently being parsed. */
      private File file;
      /** The lexer. */
      private KickCLexer lexer;

      CFile(File file, KickCLexer lexer) {
         this.file = file;
         this.lexer = lexer;
      }
   }

   public CParser(Program program) {
      this.program = program;
      this.cFiles = new LinkedHashMap<>();
      this.cTokenSource = new CTokenSource();
      final CPreprocessor preprocessor = new CPreprocessor(cTokenSource, new HashMap<>());
      this.tokenStream = new CommonTokenStream(preprocessor);
      this.parser = new KickCParser(tokenStream, this);
      this.typedefs = new ArrayList<>();
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
            throw new CompileError("Error parsing  file " + recognizer.getInputStream().getSourceName() + "\n - Line: " + line + "\n - Message: " + msg);
         }
      });
   }

   public void addTypedef(String identifier) {
      typedefs.add(identifier);
   }

   public boolean isTypedef(String identifier) {
      return typedefs.contains(identifier);
   }

   /**
    * Get the underlying token stream.
    *
    * @return The token stream
    */
   public BufferedTokenStream getTokenStream() {
      return tokenStream;
   }

   /**
    * Get the C parser
    *
    * @return The C parser
    */
   public KickCParser getParser() {
      return parser;
   }

   /**
    * Get the path of the folder containing the source file for a token
    *
    * @param context The source context to examine
    * @return The path of the folder containing the source file of the token
    */
   public Path getSourceFolderPath(ParserRuleContext context) {
      Token token = context.getStart();
      String sourceName = token.getTokenSource().getSourceName();
      CFile cFile = cFiles.get(sourceName);
      File parentFile = cFile.file.getParentFile();
      return parentFile.toPath();
   }

   /**
    * Get the path of the folder containing the source file currently being tokenized
    *
    * @return The path of the folder containing the source file currently being tokenized
    */
   private Path getCurrentSourceFolderPath() {
      TokenSource currentSource = cTokenSource.getCurrentSource();
      String sourceName = currentSource.getSourceName();
      CFile cFile = cFiles.get(sourceName);
      File file = cFile.file;
      File parentFile = file.getParentFile();
      return parentFile.toPath();
   }

   /**
    * Loads a C-file (if it has not already been loaded).
    *
    * The C-file is inserted into the C token stream at the current parse-point - so the parser will parse the entire content of the file before moving on.
    *
    * @param fileName The file name of the file
    */
   public void includeCFile(String fileName, boolean isSystem) {
      final Path currentSourceFolderPath = isSystem ? null : getCurrentSourceFolderPath();
      final KickCLexer lexer = loadCFile(fileName, currentSourceFolderPath);
      addSourceFirst(lexer);
   }

   /**
    * Loads a C-file (if it has not already been loaded).
    *
    * @param fileName The file name of the file
    * @param currentPath The path of the current folder (searched before the search path).
    * @return The lexer to be inserted into the source-list using onw of the {@link #addSourceFirst(KickCLexer)} methods.
    */
   public KickCLexer loadCFile(String fileName, Path currentPath) {
      try {
         if(fileName.startsWith("\"") || fileName.startsWith("<")) {
            fileName = fileName.substring(1, fileName.length() - 1);
         }
         if(!fileName.endsWith(".kc") && !fileName.contains(".")) {
            fileName += ".kc";
         }
         File file = SourceLoader.loadFile(fileName, currentPath, program);
         List<String> imported = program.getImported();
         if(imported.contains(file.getAbsolutePath())) {
            return null;
         }
         final CharStream fileStream = CharStreams.fromPath(file.toPath().toAbsolutePath());
         imported.add(file.getAbsolutePath());
         if(program.getLog().isVerboseParse()) {
            program.getLog().append("PARSING " + file.getPath().replace("\\", "/"));
            program.getLog().append(fileStream.toString());
         }
         KickCLexer lexer = makeLexer(fileStream);
         CFile cFile = new CFile(file, lexer);
         cFiles.put(file.getAbsolutePath(), cFile);
         return lexer;
      } catch(IOException e) {
         throw new CompileError("Error parsing file " + fileName, e);
      }
   }

   /**
    * Make a lexer for a char stream
    *
    * @param charStream the char stream
    * @return the lexer
    */
   public KickCLexer makeLexer(CharStream charStream) {
      KickCLexer lexer = new KickCLexer(charStream, this);
      lexer.addErrorListener(new BaseErrorListener() {
         @Override
         public void syntaxError(
               Recognizer<?, ?> recognizer,
               Object offendingSymbol,
               int line,
               int charPositionInLine,
               String msg,
               RecognitionException e) {
            throw new CompileError("Error parsing file " + charStream.getSourceName() + "\n - Line: " + line + "\n - Message: " + msg);
         }
      });
      return lexer;
   }


   /**
    * Add source code at the start of the token stream being parsed.
    *
    * @param lexer The lexer for reading the source tokens
    */
   public void addSourceFirst(KickCLexer lexer) {
      if(lexer != null)
         cTokenSource.addSourceFirst(lexer);
   }

   /**
    * Add source code at the end of the token stream being parsed.
    *
    * @param lexer The lexer for reading the source tokens
    */
   public void addSourceLast(KickCLexer lexer) {
      if(lexer != null)
         cTokenSource.addSourceLast(lexer);
   }


}
