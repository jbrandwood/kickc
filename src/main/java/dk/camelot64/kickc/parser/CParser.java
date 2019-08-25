package dk.camelot64.kickc.parser;

import dk.camelot64.kickc.SourceLoader;
import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.Program;
import org.antlr.v4.runtime.*;

import java.io.File;
import java.io.IOException;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Parser for C-language files.
 * <p>
 * Handles imports and multiple source files.
 * <p>
 * All state is stored in the {@link dk.camelot64.kickc.model.Program}
 */

public class CParser {

   /** The Program. */
   private Program program;

   /** The (single) parser. */
   private KickCParser parser;

   /** The token stream. */
   private final CommonTokenStream tokenStream;

   /** The token source stack handling import files. */
   private CTokenSourceStack cFileTokenStack;

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
      this.cFileTokenStack = new CTokenSourceStack();
      this.tokenStream = new CommonTokenStream(cFileTokenStack);
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

   /** Get the underlying token stream.
    *
    * @return The token stream
    */
   public BufferedTokenStream getTokenStream() {
      return tokenStream;
   }

   /**
    * Load initial C-file and start parsing it.
    * This may recursively load other C-files (if they are imported)
    *
    * @param fileName The file name to look for (in the search path)
    * @param currentPath The current path (searched before the search path)
    * @return The parse result
    */
   public KickCParser.FileContext loadAndParseCFile(String fileName, Path currentPath) {
      loadCFile(fileName, currentPath);
      return this.parser.file();
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
      TokenSource currentSource = cFileTokenStack.getCurrentSource();
      String sourceName = currentSource.getSourceName();
      CFile cFile = cFiles.get(sourceName);
      File file = cFile.file;
      File parentFile = file.getParentFile();
      return parentFile.toPath();
   }

   /**
    * Loads a C-file (if it has not already been loaded).
    * The C-file is inserted into the C token stream at the current parse-point - so the parser will parse the entire content of the file before moving on.
    *
    * @param fileName The file name of the file
    */
   public void loadCFile(String fileName) {
      loadCFile(fileName, getCurrentSourceFolderPath());
   }

   /**
    * Loads a C-file (if it has not already been loaded).
    * The C-file is inserted into the C token stream at the current parse-point - so the parser will parse the entire content of the file before moving on.
    *
    * @param fileName The file name of the file
    * @param currentPath The path of the current folder (searched before the search path).
    */
   private void loadCFile(String fileName, Path currentPath) {
      try {
         if(fileName.startsWith("\"")) {
            fileName = fileName.substring(1, fileName.length()-1);
         }
         if(!fileName.endsWith(".kc")) {
            fileName += ".kc";
         }
         File file = SourceLoader.loadFile(fileName, currentPath, program);
         List<String> imported = program.getImported();
         if(imported.contains(file.getAbsolutePath())) {
            return;
         }
         final CharStream fileStream = CharStreams.fromPath(file.toPath().toAbsolutePath());
         imported.add(file.getAbsolutePath());
         if(program.getLog().isVerboseParse()) {
            program.getLog().append("PARSING " + file.getPath().replace("\\", "/"));
            program.getLog().append(fileStream.toString());
         }
         KickCLexer lexer = new KickCLexer(fileStream, this);
         lexer.addErrorListener(new BaseErrorListener() {
            @Override
            public void syntaxError(
                  Recognizer<?, ?> recognizer,
                  Object offendingSymbol,
                  int line,
                  int charPositionInLine,
                  String msg,
                  RecognitionException e) {
               throw new CompileError("Error parsing file " + fileStream.getSourceName() + "\n - Line: " + line + "\n - Message: " + msg);
            }
         });
         CFile cFile = new CFile(file, lexer);
         cFiles.put(file.getAbsolutePath(), cFile);
         cFileTokenStack.pushSource(lexer);
      } catch(IOException e) {
         throw new CompileError("Error parsing file " + fileName, e);
      }
   }

}
