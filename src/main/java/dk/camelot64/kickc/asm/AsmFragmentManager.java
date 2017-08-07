package dk.camelot64.kickc.asm;

import dk.camelot64.kickc.CompileLog;
import dk.camelot64.kickc.asm.parser.Asm6502Lexer;
import dk.camelot64.kickc.asm.parser.Asm6502Parser;
import org.antlr.v4.runtime.*;

import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

/**
 * Provides fragments from their signature.
 * <p>
 * The first priority is loading a fragment file from the fragment-folder.
 * If no fragment file is found for the signature the manager attempts to synthesise a fragment from another fragment.
 */
public class AsmFragmentManager {

   /**
    * Cache for fragment files. Maps signature to the parsed file.
    */
   private static Map<String, Asm6502Parser.FileContext> fragmentFileCache = new HashMap<>();

   private static Asm6502Parser.FileContext UNKNOWN = new Asm6502Parser.FileContext(null, 0);

   public static Asm6502Parser.FileContext getFragment(String signature) {
      Asm6502Parser.FileContext fragment = fragmentFileCache.get(signature);
      if(fragment==UNKNOWN) {
         throw new AsmFragment.UnknownFragmentException(signature);
      }
      if (fragment == null) {
         CharStream fragmentCharStream = loadOrSynthesizeFragment(signature);
         if (fragmentCharStream == null) {
            fragmentFileCache.put(signature, UNKNOWN);
            throw new AsmFragment.UnknownFragmentException(signature);
         }
         fragment = parseFragment(fragmentCharStream, signature);
         fragmentFileCache.put(signature, fragment);
      }
      return fragment;
   }

   private static CharStream loadOrSynthesizeFragment(String signature) {
      CharStream fragmentCharStream = loadFragment(signature);
      if (fragmentCharStream == null) {
         fragmentCharStream = synthesizeFragment(signature);
      }
      return fragmentCharStream;
   }

   /**
    * Attempt to synthesize a fragment from other fragments
    *
    * @param signature The signature of the fragment to synthesize
    * @return The synthesized fragment file contents. Null if the fragment could not be synthesized.
    */
   private static CharStream synthesizeFragment(String signature) {
      if(signature.startsWith("xby=")) {
         String subSignature = "aby="+signature.substring(4);
         CharStream subCharStream = loadOrSynthesizeFragment(subSignature);
         if(subCharStream!=null) {
            CharStream result = CharStreams.fromString(subCharStream.toString()+"\ntax\n");
            return result;
         }
      }
      if(signature.startsWith("yby=")) {
         String subSignature = "aby="+signature.substring(4);
         CharStream subCharStream = loadOrSynthesizeFragment(subSignature);
         if(subCharStream!=null) {
            CharStream result = CharStreams.fromString(subCharStream.toString()+"\ntay\n");
            return result;
         }
      }
      if(signature.startsWith("zpby1=")) {
         String subSignature = "aby="+signature.substring(6).replace("zpby2", "zpby1");
         CharStream subCharStream = loadOrSynthesizeFragment(subSignature);
         if(subCharStream!=null) {
            CharStream result = CharStreams.fromString(subCharStream.toString().replace("zpby1", "zpby2")+"\nsta {zpby1}\n");
            return result;
         }
      }
      if(signature.contains("_lt_xby_then_")) {
         int pos = signature.indexOf("_lt_xby_then_");
         String subSignature = "xby_gte_"+signature.substring(0, pos)+"_then_"+signature.substring(pos+13);
         return loadOrSynthesizeFragment(subSignature);
      }
      if(signature.contains("_lt_yby_then_")) {
         int pos = signature.indexOf("_lt_yby_then_");
         String subSignature = "yby_gte_"+signature.substring(0, pos)+"_then_"+signature.substring(pos+13);
         return loadOrSynthesizeFragment(subSignature);
      }
      if(signature.contains("_lt_aby_then_")) {
         int pos = signature.indexOf("_lt_aby_then_");
         String subSignature = "aby_gte_"+signature.substring(0, pos)+"_then_"+signature.substring(pos+13);
         return loadOrSynthesizeFragment(subSignature);
      }

      return null;
   }


   /**
    * Look for a fragment on the disk.
    *
    * @param signature The fragment signature
    * @return The fragment file contents. Null if the fragment is not on the disk.
    */
   private static CharStream loadFragment(String signature) {
      ClassLoader classLoader = AsmFragmentManager.class.getClassLoader();
      URL fragmentUrl = classLoader.getResource("dk/camelot64/kickc/asm/fragment/" + signature + ".asm");
      if(fragmentUrl==null) {
         return null;
      }
      try {
         InputStream fragmentStream = fragmentUrl.openStream();
         return CharStreams.fromStream(fragmentStream);
      } catch (IOException e) {
         throw new RuntimeException("Error loading fragment file " + fragmentUrl);
      }
   }

   /**
    * Parse an ASM fragment.
    *
    * @param fragmentCharStream The stream containing the fragment syntax
    * @param fragmentFileName   The filename (used in error messages)
    * @return The parsed fragment ready for generating
    * @throws IOException if the parsing/loading fails
    */
   private static Asm6502Parser.FileContext parseFragment(CharStream fragmentCharStream, final String fragmentFileName) {
      Asm6502Parser.FileContext fragmentFile;
      Asm6502Lexer lexer = new Asm6502Lexer(fragmentCharStream);
      Asm6502Parser parser = new Asm6502Parser(new CommonTokenStream(lexer));
      parser.addErrorListener(new BaseErrorListener() {
         @Override
         public void syntaxError(Recognizer<?, ?> recognizer, Object offendingSymbol, int line, int charPositionInLine, String msg, RecognitionException e) {
            throw new RuntimeException("Error parsing fragment fragmentFile " + fragmentFileName + "\n - Line: " + line + "\n - Message: " + msg);
         }
      });
      parser.setBuildParseTree(true);
      fragmentFile = parser.file();
      return fragmentFile;
   }


}
