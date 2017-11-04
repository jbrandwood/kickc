package dk.camelot64.kickc.fragment;

import dk.camelot64.kickc.asm.parser.Asm6502Lexer;
import dk.camelot64.kickc.asm.parser.Asm6502Parser;
import org.antlr.v4.runtime.*;

import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

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

   public static AsmFragment getFragment(AsmFragmentSignature signature) {
      Asm6502Parser.FileContext fragmentFile = getFragmentFile(signature.getSignature());
      AsmFragment fragment = new AsmFragment(
            signature.getProgram(),
            signature.getSignature(),
            signature.getCodeScope(),
            fragmentFile,
            signature.getBindings());
      return fragment;
   }

   private static Asm6502Parser.FileContext getFragmentFile(String signature) {
      Asm6502Parser.FileContext fragment = fragmentFileCache.get(signature);
      if (fragment == UNKNOWN) {
         throw new UnknownFragmentException(signature);
      }
      if (fragment == null) {
         CharStream fragmentCharStream = loadOrSynthesizeFragment(signature);
         if (fragmentCharStream == null) {
            fragmentFileCache.put(signature, UNKNOWN);
            throw new UnknownFragmentException(signature);
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

      String sigNew = signature;
      sigNew = regexpRewriteSignature(sigNew, "(.*)=(.*)_band_aby", "$1=aby_band_$2");
      sigNew = regexpRewriteSignature(sigNew, "(.*)=(.*)_band_xby", "$1=xby_band_$2");
      sigNew = regexpRewriteSignature(sigNew, "(.*)=(.*)_band_yby", "$1=yby_band_$2");
      sigNew = regexpRewriteSignature(sigNew, "(.*)=(.*)_bor_aby", "$1=aby_bor_$2");
      sigNew = regexpRewriteSignature(sigNew, "(.*)=(.*)_bor_xby", "$1=xby_bor_$2");
      sigNew = regexpRewriteSignature(sigNew, "(.*)=(.*)_bor_yby", "$1=yby_bor_$2");
      sigNew = regexpRewriteSignature(sigNew, "(.*)=(.*)_plus_aby", "$1=aby_plus_$2");
      sigNew = regexpRewriteSignature(sigNew, "(.*)=(.*)_plus_xby", "$1=xby_plus_$2");
      sigNew = regexpRewriteSignature(sigNew, "(.*)=(.*)_plus_yby", "$1=yby_plus_$2");
      sigNew = regexpRewriteSignature(sigNew, "(.*)_lt_aby_then_(.*)", "aby_ge_$1_then_$2");
      sigNew = regexpRewriteSignature(sigNew, "(.*)_lt_xby_then_(.*)", "xby_ge_$1_then_$2");
      sigNew = regexpRewriteSignature(sigNew, "(.*)_lt_yby_then_(.*)", "yby_ge_$1_then_$2");
      sigNew = regexpRewriteSignature(sigNew, "(.*)_ge_aby_then_(.*)", "aby_lt_$1_then_$2");
      sigNew = regexpRewriteSignature(sigNew, "(.*)_ge_xby_then_(.*)", "xby_lt_$1_then_$2");
      sigNew = regexpRewriteSignature(sigNew, "(.*)_ge_yby_then_(.*)", "yby_lt_$1_then_$2");
      sigNew = regexpRewriteSignature(sigNew, "(.*)_gt_aby_then_(.*)", "aby_le_$1_then_$2");
      sigNew = regexpRewriteSignature(sigNew, "(.*)_gt_xby_then_(.*)", "xby_le_$1_then_$2");
      sigNew = regexpRewriteSignature(sigNew, "(.*)_gt_yby_then_(.*)", "yby_le_$1_then_$2");
      sigNew = regexpRewriteSignature(sigNew, "(.*)_neq_aby_then_(.*)", "aby_neq_$1_then_$2");
      sigNew = regexpRewriteSignature(sigNew, "(.*)_neq_xby_then_(.*)", "xby_neq_$1_then_$2");
      sigNew = regexpRewriteSignature(sigNew, "(.*)_neq_yby_then_(.*)", "yby_neq_$1_then_$2");
      if (!signature.equals(sigNew)) {
         CharStream loadFragment = loadFragment(sigNew);
         if(loadFragment!=null) {
            return loadFragment;
         } else {
            signature = sigNew;
         }
      }

      if (signature.startsWith("xby=")) {
         String subSignature = "aby=" + signature.substring(4);
         CharStream subCharStream = loadOrSynthesizeFragment(subSignature);
         if (subCharStream != null) {
            CharStream result = CharStreams.fromString(subCharStream.toString() + "\ntax\n");
            return result;
         }
      }
      if (signature.startsWith("yby=")) {
         String subSignature = "aby=" + signature.substring(4);
         CharStream subCharStream = loadOrSynthesizeFragment(subSignature);
         if (subCharStream != null) {
            CharStream result = CharStreams.fromString(subCharStream.toString() + "\ntay\n");
            return result;
         }
      }
      if (signature.startsWith("zpby1=")) {
         String subSignature = "aby=" + signature.substring(6).replace("zpby1", "aby").replace("zpby2", "zpby1").replace("zpby3", "zpby2");
         CharStream subCharStream = loadOrSynthesizeFragment(subSignature);
         if (subCharStream != null) {
            CharStream result = CharStreams.fromString(subCharStream.toString().replace("zpby2", "zpby3").replace("zpby1", "zpby2") + "\nsta {zpby1}\n");
            return result;
         }
      }
      if (signature.contains("=zpby1_") && !signature.matches(".*=.*aby.*")) {
         String subSignature = regexpRewriteSignature(signature, "(.*)=zpby1_(.*)", "$1=aby_$2").replace("zpby2", "zpby1").replace("zpby3", "zpby2");
         CharStream subCharStream = loadOrSynthesizeFragment(subSignature);
         if (subCharStream != null) {
            CharStream result = CharStreams.fromString("lda {zpby1}\n"+subCharStream.toString().replace("zpby2", "zpby3").replace("zpby1", "zpby2"));
            return result;
         }
      }
      if (signature.contains("=xby_") && !signature.matches(".*=.*aby.*")) {
         String subSignature = regexpRewriteSignature(signature, "(.*)=xby_(.*)", "$1=aby_$2");
         CharStream subCharStream = loadOrSynthesizeFragment(subSignature);
         if (subCharStream != null) {
            CharStream result = CharStreams.fromString("txa\n"+subCharStream.toString());
            return result;
         }
      }
      if (signature.contains("=yby_") && !signature.matches(".*=.*aby.*")) {
         String subSignature = regexpRewriteSignature(signature, "(.*)=yby_(.*)", "$1=aby_$2");
         CharStream subCharStream = loadOrSynthesizeFragment(subSignature);
         if (subCharStream != null) {
            CharStream result = CharStreams.fromString("tya\n"+subCharStream.toString());
            return result;
         }
      }
      if (signature.endsWith("_staridx_aby") && !signature.matches(".*=.*yby.*")) {
         String subSignature = regexpRewriteSignature(signature, "(.*)=(.*)_staridx_aby", "$1=$2_staridx_yby");
         CharStream subCharStream = loadOrSynthesizeFragment(subSignature);
         if (subCharStream != null) {
            CharStream result = CharStreams.fromString("tay\n"+subCharStream.toString());
            return result;
         }
      }
      if (signature.endsWith("_staridx_aby") && !signature.matches(".*=.*xby.*")) {
         String subSignature = regexpRewriteSignature(signature, "(.*)=(.*)_staridx_aby", "$1=$2_staridx_xby");
         CharStream subCharStream = loadOrSynthesizeFragment(subSignature);
         if (subCharStream != null) {
            CharStream result = CharStreams.fromString("tax\n"+subCharStream.toString());
            return result;
         }
      }
      if (signature.endsWith("_staridx_zpby1") && !signature.matches(".*=.*yby.*")) {
         String subSignature = regexpRewriteSignature(signature, "(.*)=(.*)_staridx_zpby1", "$1=$2_staridx_yby").replace("zpby2", "zpby1").replace("zpby3", "zpby2");
         CharStream subCharStream = loadOrSynthesizeFragment(subSignature);
         if (subCharStream != null) {
            CharStream result = CharStreams.fromString("ldy {zpby1}\n"+subCharStream.toString().replace("zpby2", "zpby3").replace("zpby1", "zpby2"));
            return result;
         }
      }
      if (signature.endsWith("_staridx_zpby1") && !signature.matches(".*=.*xby.*")) {
         String subSignature = regexpRewriteSignature(signature, "(.*)=(.*)_staridx_zpby1", "$1=$2_staridx_xby").replace("zpby2", "zpby1").replace("zpby3", "zpby2");
         CharStream subCharStream = loadOrSynthesizeFragment(subSignature);
         if (subCharStream != null) {
            CharStream result = CharStreams.fromString("ldx {zpby1}\n"+subCharStream.toString().replace("zpby2", "zpby3").replace("zpby1", "zpby2"));
            return result;
         }
      }

      return null;

   }

   private static String regexpRewriteSignature(String signature, String match, String replace) {
      Pattern p = Pattern.compile(match);
      Matcher m = p.matcher(signature);
      String output = signature;
      if (m.find()) {
         // getReplacement first number with "number" and second number with the first
         output = m.replaceAll(replace);
      }
      return output;
   }


   /**
    * Look for a fragment on the disk.
    *
    * @param signature The fragment signature
    * @return The fragment file contents. Null if the fragment is not on the disk.
    */
   private static CharStream loadFragment(String signature) {
      ClassLoader classLoader = AsmFragmentManager.class.getClassLoader();
      URL fragmentUrl = classLoader.getResource("dk/camelot64/kickc/fragment/asm/" + signature + ".asm");
      if (fragmentUrl == null) {
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


   public static class UnknownFragmentException extends RuntimeException {

      private String fragmentSignature;

      public UnknownFragmentException(String signature) {
         super("Fragment not found " + signature + ".asm");
         this.fragmentSignature = signature;
      }

      public String getFragmentSignature() {
         return fragmentSignature;
      }
   }
}
