package dk.camelot64.kickc.parser;

import dk.camelot64.kickc.FileNameUtils;
import dk.camelot64.kickc.SourceLoader;
import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.TargetPlatform;
import dk.camelot64.kickc.model.statements.StatementSource;
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

   /** Pragma Names. */
   public static final String PRAGMA_TARGET = "target";
   public static final String PRAGMA_CPU = "cpu";
   public static final String PRAGMA_VAR_MODEL = "var_model";
   public static final String PRAGMA_LINKSCRIPT = "link";
   public static final String PRAGMA_EXTENSION = "extension";
   public static final String PRAGMA_EMULATOR = "emulator";
   public static final String PRAGMA_ENCODING = "encoding";
   public static final String PRAGMA_CODE_SEG = "code_seg";
   public static final String PRAGMA_DATA_SEG = "data_seg";
   public static final String PRAGMA_START_ADDRESS = "start_address";
   public static final String PRAGMA_CALLING = "calling";
   public static final String PRAGMA_ZP_RESERVE = "zp_reserve";
   public static final String PRAGMA_CONSTRUCTOR_FOR = "constructor_for";
   public static final String PRAGMA_INTERRUPT = "interrupt";

   /** The Program. */
   private Program program;

   /** The (single) parser. */
   private KickCParser parser;

   /** The preprocessor. */
   private CPreprocessor preprocessor;

   /** The token stream. */
   private final CommonTokenStream preprocessedTokenStream;

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
      this.preprocessor = new CPreprocessor(this, cTokenSource, new HashMap<>());
      this.preprocessedTokenStream = new CommonTokenStream(preprocessor);
      this.parser = new KickCParser(preprocessedTokenStream, this);
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
            final CommonToken offendingToken = (CommonToken) offendingSymbol;
            StatementSource source = new StatementSource(offendingToken.getInputStream().getSourceName(), line, charPositionInLine, null, -1, -1);
            throw new CompileError("Error parsing file: " + msg, source);
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
    * Get the preprocessor (usable for getting all preprocessed tokens).
    *
    * @return The preprocessor
    */
   public CPreprocessor getPreprocessor() {
      return preprocessor;
   }

   /**
    * Define a new macro
    *
    * @param macroName The macro name
    * @param macroBody The macro body
    */
   public void define(String macroName, String macroBody) {
      final String macroBodyText = "#define " + macroName + " " + macroBody + "\n";
      final CodePointCharStream macroCharStream = CharStreams.fromString(macroBodyText);
      final KickCLexer macroLexer = makeLexer(macroCharStream);
      addSourceFirst(macroLexer);
   }

   /**
    * Undef a macro
    *
    * @param macroName The macro name
    */
   public void undef(String macroName) {
      getPreprocessor().undef(macroName);
   }

   /**
    * Get the token stream containing tokens after the preprocessor.
    *
    * @return The preprocessed token stream
    */
   public BufferedTokenStream getPreprocessedTokenStream() {
      return preprocessedTokenStream;
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
   public Path getCurrentSourceFolderPath() {
      TokenSource currentSource = cTokenSource.getCurrentSource();
      String sourceName = currentSource.getSourceName();
      CFile cFile = cFiles.get(sourceName);
      File file = cFile.file;
      File parentFile = file.getParentFile();
      return parentFile.toPath();
   }

   /**
    * Loads a C-file (if it has not already been loaded).
    * <p>
    * The C-file is inserted into the C token stream at the current parse-point - so the parser will parse the entire content of the file before moving on.
    *
    * @param fileName The file name of the file
    */
   public void includeCFile(String fileName, boolean isSystem) {
      if(fileName.startsWith("\"") || fileName.startsWith("<")) {
         fileName = fileName.substring(1, fileName.length() - 1);
      }
      final Path currentSourceFolderPath = isSystem ? null : getCurrentSourceFolderPath();
      final TokenSource fileTokens = loadCFile(fileName, currentSourceFolderPath, program.getIncludePaths(), false);
      if(fileName.endsWith(".h")) {
         // The included file was a H-file - attempt to find the matching library C-file
         String libFileName = FileNameUtils.removeExtension(fileName) + ".c";
         final TokenSource cLibFileTokens = loadCFile(libFileName, currentSourceFolderPath, program.getLibraryPaths(), true);
         addSourceFirst(cLibFileTokens);
      }
      addSourceFirst(fileTokens);
   }

   /**
    * Loads a C-file (if it has not already been loaded).
    *
    * @param fileName The file name of the file
    * @param currentPath The path of the current folder (searched before the search path).
    * @param searchPaths The folders to look in if the files is not found in current path
    * @return The lexer tokens to be inserted into the source-list using one of the {@link #addSourceFirst(TokenSource)} / {@link #addSourceLast(TokenSource)} methods.
    */
   public TokenSource loadCFile(String fileName, Path currentPath, List<String> searchPaths, boolean acceptFileNotFound) {
      try {
         File file = SourceLoader.loadFile(fileName, currentPath, searchPaths);
         if(file == null)
            if(acceptFileNotFound)
               return null;
            else
               throw new CompileError("File not found " + fileName);
         List<String> included = program.getLoadedFiles();
         if(included.contains(file.getAbsolutePath())) {
            return null;
         }
         final CharStream fileStream = CharStreams.fromPath(file.toPath().toAbsolutePath());
         included.add(file.getAbsolutePath());
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

   public void loadTargetPlatform(String platformName, Path currentPath) {
      final File platformFile = SourceLoader.loadFile(platformName + "." + CTargetPlatformParser.FILE_EXTENSION, currentPath, program.getTargetPlatformPaths());
      if(platformFile != null) {
         final TargetPlatform targetPlatform = CTargetPlatformParser.parseTargetPlatformFile(platformName, platformFile, currentPath, program.getTargetPlatformPaths());
         // Remove macros from existing platform!
         if(program.getTargetPlatform() != null && program.getTargetPlatform().getDefines() != null)
            for(String macroName : program.getTargetPlatform().getDefines().keySet())
               preprocessor.undef(macroName);
         // Remove reserved ZP's from existing platform
         program.getReservedZps().removeAll(program.getTargetPlatform().getReservedZps());

         // Set the new program platform
         program.setTargetPlatform(targetPlatform);
         // Define macros from new platform!
         if(program.getTargetPlatform().getDefines() != null)
            for(String macroName : program.getTargetPlatform().getDefines().keySet())
               define(macroName, program.getTargetPlatform().getDefines().get(macroName));
         // Add reserved ZP's from new platform
         program.addReservedZps(program.getTargetPlatform().getReservedZps());
         // Set the output file extension
         program.getOutputFileManager().setBinaryExtension(targetPlatform.getOutFileExtension());

      } else {
         StringBuilder supported = new StringBuilder();
         final List<File> platformFiles = SourceLoader.listFiles(currentPath, program.getTargetPlatformPaths(), CTargetPlatformParser.FILE_EXTENSION);
         for(File file : platformFiles) {
            String name = file.getName();
            name = name.substring(0, name.length() - CTargetPlatformParser.FILE_EXTENSION.length() - 1);
            supported.append(name).append(" ");
         }
         throw new CompileError("Unknown target platform '" + platformName + "'. Supported: " + supported.toString());
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
            StatementSource source = new StatementSource(charStream.getSourceName(), line, charPositionInLine, null, -1,-1);
            throw new CompileError("Error parsing file: " + msg, source);
         }
      });
      return lexer;
   }


   /**
    * Add source code at the start of the token stream being parsed.
    *
    * @param tokenSource The lexer for reading the source tokens
    */
   public void addSourceFirst(TokenSource tokenSource) {
      if(tokenSource != null)
         cTokenSource.addSourceFirst(tokenSource);
   }

   /**
    * Add source code at the end of the token stream being parsed.
    *
    * @param tokenSource The lexer for reading the source tokens
    */
   public void addSourceLast(TokenSource tokenSource) {
      if(tokenSource != null)
         cTokenSource.addSourceLast(tokenSource);
   }


}
