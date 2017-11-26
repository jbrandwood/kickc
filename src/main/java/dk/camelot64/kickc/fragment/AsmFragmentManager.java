package dk.camelot64.kickc.fragment;

import dk.camelot64.kickc.CompileLog;
import dk.camelot64.kickc.parser.KickCLexer;
import dk.camelot64.kickc.parser.KickCParser;
import org.antlr.v4.runtime.*;

import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Provides fragments from their signature.
 * <p>
 * The first priority is loading a fragment file from the fragment-folder.
 * If no fragment file is found for the signature the manager attempts to synthesise a fragment from another fragment.
 */
public class AsmFragmentManager {

   static boolean verboseFragmentLog = false;

   /**
    * Cache for fragment files. Maps signature to the parsed file.
    */
   private static Map<String, KickCParser.AsmFileContext> fragmentFileCache = new HashMap<>();

   private static KickCParser.AsmFileContext UNKNOWN = new KickCParser.AsmFileContext(null, 0);

   public static AsmFragment getFragment(AsmFragmentSignature signature, CompileLog log) {
      KickCParser.AsmFileContext fragmentFile = getFragmentFile(signature.getSignature(), log);
      AsmFragment fragment = new AsmFragment(
            signature.getProgram(),
            signature.getSignature(),
            signature.getCodeScope(),
            fragmentFile.asmLines(),
            signature.getBindings());
      return fragment;
   }

   private static KickCParser.AsmFileContext getFragmentFile(String signature, CompileLog log) {
      KickCParser.AsmFileContext fragment = fragmentFileCache.get(signature);
      if (fragment == UNKNOWN) {
         if (verboseFragmentLog) {
            log.append("Unknown fragment " + signature);
         }
         throw new UnknownFragmentException(signature);
      }
      if (fragment == null) {
         CharStream fragmentCharStream = loadOrSynthesizeFragment(signature, log);
         if (fragmentCharStream == null) {
            if (verboseFragmentLog) {
               log.append("Unknown fragment " + signature);
            }
            fragmentFileCache.put(signature, UNKNOWN);
            throw new UnknownFragmentException(signature);
         }
         fragment = parseFragment(fragmentCharStream, signature);
         fragmentFileCache.put(signature, fragment);
      }
      return fragment;
   }

   private static CharStream loadOrSynthesizeFragment(String signature, CompileLog log) {
      CharStream fragmentCharStream = loadFragment(signature);
      if (fragmentCharStream == null) {
         if (verboseFragmentLog) {
            log.append("Attempting fragment synthesis " + signature);
         }
         fragmentCharStream = synthesizeFragment(signature, log);
      } else {
         if (verboseFragmentLog) {
            log.append("Succesfully loaded fragment " + signature);
         }
      }
      return fragmentCharStream;
   }

   /**
    * Attempt to synthesize a fragment from other fragments
    *
    * @param signature The signature of the fragment to synthesize
    * @return The synthesized fragment file contents. Null if the fragment could not be synthesized.
    */
   private static CharStream synthesizeFragment(String signature, CompileLog log) {

      Map<String, String> mapZpsby = new LinkedHashMap<>();
      mapZpsby.put("zpsby2", "zpsby1");
      mapZpsby.put("zpsby3", "zpsby2");
      Map<String, String> mapZpby = new LinkedHashMap<>();
      mapZpby.put("zpby2", "zpby1");
      mapZpby.put("zpby3", "zpby2");
      Map<String, String> mapZpptrby = new LinkedHashMap<>();
      mapZpptrby.put("zpptrby2", "zpptrby1");
      mapZpptrby.put("zpptrby3", "zpptrby2");
      Map<String, String> mapConst = new LinkedHashMap<>();
      mapConst.put("cowo2", "cowo1");
      mapConst.put("cowo3", "cowo2");
      mapConst.put("coby2", "coby1");
      mapConst.put("coby3", "coby2");
      Map<String, String> mapZpptrToWord = new LinkedHashMap<>();
      mapZpptrToWord.put("zpptrby1", "zpwo1");
      mapZpptrToWord.put("zpptrby2", "zpwo2");
      mapZpptrToWord.put("zpptrby3", "zpwo3");
      Map<String, String> mapZpptrToWord2 = new LinkedHashMap<>();
      mapZpptrToWord2.put("zpwo1", "zpwo2");
      mapZpptrToWord2.put("zpptrby1", "zpwo1");
      Map<String, String> mapZpptrToWord3 = new LinkedHashMap<>();
      mapZpptrToWord3.put("zpwo1", "zpwo3");
      mapZpptrToWord3.put("zpptrby1", "zpwo1");
      mapZpptrToWord3.put("zpptrby2", "zpwo2");
      Map<String, String> mapSbyToBy = new LinkedHashMap<>();
      mapSbyToBy.put("zpsby1", "zpby1");
      mapSbyToBy.put("zpsby2", "zpby2");
      mapSbyToBy.put("zpsby3", "zpby3");
      mapSbyToBy.put("cosby1", "coby1");
      mapSbyToBy.put("cosby2", "coby2");
      mapSbyToBy.put("cosby3", "coby3");
      mapSbyToBy.put("asby", "aby");
      mapSbyToBy.put("xsby", "xby");
      mapSbyToBy.put("ysby", "yby");

      List<FragmentSynthesis> synths = new ArrayList<>();

      synths.add(new FragmentSynthesis("(.*)=(.*)_(band|bor|bxor|plus)_(as?by)", ".*=as?by_.*", null, "$1=$4_$3_$2", null, null));
      synths.add(new FragmentSynthesis("(.*)=(.*)_(band|bor|bxor|plus)_(xs?by)", ".*=[xa]s?by_.*", null, "$1=$4_$3_$2", null, null));
      synths.add(new FragmentSynthesis("(.*)=(.*)_(band|bor|bxor|plus)_(ys?by)", ".*=[axy]s?by_.*", null, "$1=$4_$3_$2", null, null));

      synths.add(new FragmentSynthesis("xby=(.*)", null, null, "aby=$1", "tax\n", null));
      synths.add(new FragmentSynthesis("xsby=(.*)", null, null, "asby=$1", "tax\n", null));
      synths.add(new FragmentSynthesis("yby=(.*)", null, null, "aby=$1", "tay\n", null));
      synths.add(new FragmentSynthesis("ysby=(.*)", null, null, "asby=$1", "tay\n", null));
      synths.add(new FragmentSynthesis("zpby1=(.*)", ".*=.*zpby1.*", null, "aby=$1", "sta {zpby1}\n", mapZpby));
      synths.add(new FragmentSynthesis("zpsby1=(.*)", ".*=.*zpsby1.*", null, "asby=$1", "sta {zpsby1}\n", mapZpsby));
      synths.add(new FragmentSynthesis("_deref_cowo1=(.*)", null, null, "aby=$1", "sta {cowo1}\n", mapConst));
      synths.add(new FragmentSynthesis("_deref_zpptrby1=(.*)", ".*=.*zpptrby1.*", null, "aby=$1", "ldy #0\n" + "sta ({zpptrby1}),y\n", mapZpptrby));
      synths.add(new FragmentSynthesis("cowo1_derefidx_zpby1=(.*)", null, null, "aby=$1", "ldx {zpby1}\n"+"sta {cowo1},x\n", mapZpby));

      synths.add(new FragmentSynthesis("(.*)=xby(.*)", ".*=.*as?by.*", "txa\n", "$1=aby$2", null, null));
      synths.add(new FragmentSynthesis("(.*)=yby(.*)", ".*=.*as?by.*", "tya\n", "$1=aby$2", null, null));
      synths.add(new FragmentSynthesis("(.*)=zpby1(.*)", ".*=.*as?by.*|zpby1=.*", "lda {zpby1}\n", "$1=aby$2", null, mapZpby));
      synths.add(new FragmentSynthesis("(.*)=zpsby1(.*)", ".*=.*as?by.*|zpsby1=.*", "lda {zpsby1}\n", "$1=aby$2", null, mapZpsby));
      synths.add(new FragmentSynthesis("(.*)=_deref_cowo1(.*)", ".*=.*as?by.*", "lda {cowo1}\n", "$1=aby$2", null, mapConst));
      synths.add(new FragmentSynthesis("(.*)=_deref_zpptrby1(.*)", ".*=.*as?by.*|.*=.*ys?by.*", "ldy #0\n" + "lda ({zpptrby1}),y\n", "$1=aby$2", null, mapZpptrby));

      synths.add(new FragmentSynthesis("(.*)=(.*)_xby", ".*=[ax]s?by.*xs?by|.*derefidx_xs?by", "txa\n", "$1=$2_aby", null, null));
      synths.add(new FragmentSynthesis("(.*)=(.*)_xsby", ".*=[ax]s?by.*xs?by|.*derefidx_xs?by", "txa\n", "$1=$2_asby", null, null));
      synths.add(new FragmentSynthesis("(.*)=(.*)_yby", ".*=[ay]s?by.*ys?by|.*derefidx_ys?by", "tya\n", "$1=$2_aby", null, null));
      synths.add(new FragmentSynthesis("(.*)=(.*)_ysby", ".*=[ay]s?by.*ys?by|.*derefidx_ys?by", "tya\n", "$1=$2_asby", null, null));
      synths.add(new FragmentSynthesis("(.*)=(.*)_zpby1", ".*=.*as?by.*", "lda {zpby1}\n", "$1=$2_aby", null, mapZpby));
      synths.add(new FragmentSynthesis("(.*)=(.*)_zpsby1", ".*=.*as?by.*", "lda {zpsby1}\n", "$1=$2_asby", null, mapZpsby));

      synths.add(new FragmentSynthesis("zpby1=zpby1(.*)", ".*=.*as?by.*", "lda {zpby1}\n", "aby=aby$1", "sta {zpby1}\n", mapZpby));
      synths.add(new FragmentSynthesis("zpsby1=zpsby1(.*)", ".*=.*as?by.*", "lda {zpsby1}\n", "asby=asby$1", "sta {zpsby1}\n", mapZpby));

      synths.add(new FragmentSynthesis("(.*)=(.*)_derefidx_aby", ".*=.*ys?by.*", "tay\n", "$1=$2_derefidx_yby", null, null));
      synths.add(new FragmentSynthesis("(.*)=(.*)_derefidx_aby", ".*=.*xs?by.*", "tax\n", "$1=$2_derefidx_xby", null, null));
      synths.add(new FragmentSynthesis("(.*)=(.*)_derefidx_zpby1", ".*=.*ys?by.*", "ldy {zpby1}\n", "$1=$2_derefidx_yby", null, mapZpby));
      synths.add(new FragmentSynthesis("(.*)=(.*)_derefidx_zpby1", ".*=.*xs?by.*", "ldx {zpby1}\n", "$1=$2_derefidx_xby", null, mapZpby));

      synths.add(new FragmentSynthesis("zpby1_(lt|gt|le|ge|eq|neq)_(.*)", ".*as?by.*", "lda {zpby1}\n", "aby_$1_$2", null, mapZpby));
      synths.add(new FragmentSynthesis("zpsby1_(lt|gt|le|ge|eq|neq)_(.*)", ".*as?by.*", "lda {zpsby1}\n", "asby_$1_$2", null, mapZpsby));
      synths.add(new FragmentSynthesis("_deref_cowo1_(lt|gt|le|ge|eq|neq)_(.*)", ".*as?by.*", "lda {cowo1}\n", "aby_$1_$2", null, mapConst));
      synths.add(new FragmentSynthesis("_deref_zpptrby1_(lt|gt|le|ge|eq|neq)_(.*)", ".*=.*as?by.*|.*=.*ys?by.*", "ldy #0\n" + "lda ({zpptrby1}),y\n", "aby_$1_$2", null, mapZpptrby));
      synths.add(new FragmentSynthesis("(.*)_ge_(as?by)_then_(.*)", ".*[a]s?by.*_ge.*", null, "$2_lt_$1_then_$3", null, null));
      synths.add(new FragmentSynthesis("(.*)_ge_(xs?by)_then_(.*)", ".*[ax]s?by.*_ge.*", null, "$2_lt_$1_then_$3", null, null));
      synths.add(new FragmentSynthesis("(.*)_ge_(ys?by)_then_(.*)", ".*[axy]s?by.*_ge.*", null, "$2_lt_$1_then_$3", null, null));
      synths.add(new FragmentSynthesis("(.*)_lt_(as?by)_then_(.*)", ".*[a]s?by.*_lt.*", null, "$2_ge_$1_then_$3", null, null));
      synths.add(new FragmentSynthesis("(.*)_lt_(xs?by)_then_(.*)", ".*[ax]s?by.*_lt.*", null, "$2_ge_$1_then_$3", null, null));
      synths.add(new FragmentSynthesis("(.*)_lt_(ys?by)_then_(.*)", ".*[axy]s?by.*_lt.*", null, "$2_ge_$1_then_$3", null, null));
      synths.add(new FragmentSynthesis("(.*)_gt_(as?by)_then_(.*)", ".*[a]s?by.*_gt.*", null, "$2_le_$1_then_$3", null, null));
      synths.add(new FragmentSynthesis("(.*)_gt_(xs?by)_then_(.*)", ".*[ax]s?by.*_gt.*", null, "$2_le_$1_then_$3", null, null));
      synths.add(new FragmentSynthesis("(.*)_gt_(ys?by)_then_(.*)", ".*[axy]s?by.*_gt.*", null, "$2_le_$1_then_$3", null, null));
      synths.add(new FragmentSynthesis("(.*)_le_(as?by)_then_(.*)", ".*[a]s?by.*_le.*", null, "$2_gt_$1_then_$3", null, null));
      synths.add(new FragmentSynthesis("(.*)_le_(xs?by)_then_(.*)", ".*[ax]s?by.*_le.*", null, "$2_gt_$1_then_$3", null, null));
      synths.add(new FragmentSynthesis("(.*)_le_(ys?by)_then_(.*)", ".*[axy]s?by.*_le.*", null, "$2_gt_$1_then_$3", null, null));
      synths.add(new FragmentSynthesis("(.*)_neq_(as?by)_then_(.*)", ".*[a]s?by.*_neq.*", null, "$2_neq_$1_then_$3", null, null));
      synths.add(new FragmentSynthesis("(.*)_neq_(xs?by)_then_(.*)", ".*[ax]s?by.*_neq.*", null, "$2_neq_$1_then_$3", null, null));
      synths.add(new FragmentSynthesis("(.*)_neq_(ys?by)_then_(.*)", ".*[axy]s?by.*_neq.*", null, "$2_neq_$1_then_$3", null, null));
      synths.add(new FragmentSynthesis("(.*)_eq_(as?by)_then_(.*)", ".*[a]s?by.*_eq.*", null, "$2_eq_$1_then_$3", null, null));
      synths.add(new FragmentSynthesis("(.*)_eq_(xs?by)_then_(.*)", ".*[ax]s?by.*_eq.*", null, "$2_eq_$1_then_$3", null, null));
      synths.add(new FragmentSynthesis("(.*)_eq_(ys?by)_then_(.*)", ".*[axy]s?by.*_eq.*", null, "$2_eq_$1_then_$3", null, null));

      synths.add(new FragmentSynthesis("zpptrby1=(coby.|cowo.)_(sethi|setlo|plus|minus)_(.*)", ".*zpwo.*|.*=zpptr.*", null, "zpwo1=$1_$2_$3", null, mapZpptrToWord));
      synths.add(new FragmentSynthesis("zpptrby1=zpptrby([12])_(sethi|setlo|plus|minus)_(.*)", ".*zpwo.*", null, "zpwo1=zpwo$1_$2_$3", null, mapZpptrToWord));
      synths.add(new FragmentSynthesis("zpptrby1=zpptrby1_(sethi|setlo|plus|minus)_zpwo1", null, null, "zpptrby1=zpptrby1_$1_zpwo1", null, mapZpptrToWord2));
      synths.add(new FragmentSynthesis("zpptrby1=zpptrby2_(sethi|setlo|plus|minus)_zpwo1", null, null, "zpptrby1=zpptrby2_$1_zpwo1", null, mapZpptrToWord3));

      synths.add(new FragmentSynthesis("(zpsby.|asby|xsby|ysby)_(eq|neq)_(zpsby.|csoby.|asby|xsby|ysby)_then_(.*)", null, null, "$1_$2_$3_then_$4", null, mapSbyToBy));
      synths.add(new FragmentSynthesis("(zpsby.|asby|xsby|ysby)=(zpsby.|cosby.|asby|xsby|ysby)", null, null, "$1=$2", null, mapSbyToBy));
      synths.add(new FragmentSynthesis("(zpsby.|asby|xsby|ysby)=(zpsby.|csoby.|asby|xsby|ysby)_(plus|band|bxor|bor)_(zpsby.|csoby.|asby|xsby|ysby)", null, null, "$1=$2_$3_$4", null, mapSbyToBy));

      for (FragmentSynthesis synth : synths) {
         CharStream synthesized = synth.synthesize(signature, log);
         if (synthesized != null) {
            if (verboseFragmentLog) {
               log.append("Succesfully synthesized fragment " + signature + " (from " + synth.getSubSignature() + ")");
            }
            return synthesized;
         }
      }

      return null;

   }

   /**
    * Bindings/mappings used when synthesizing one fragment from another fragment.
    * Eg. when synthesizing zpby1=zpby2_plus_zpby3 from aby=zpby1_plus_zpby2 the bindings (zpby2->zpby1, zpby3->zpby2) are used.
    * <p>
    * Often the same bindings are used in the signature-name and in the asm-code, but the bindings can be different.
    * Eg. when synthesizing zpptrby1=zpptrby2_plus_zpwo1 from zpwo1=zpwo2_plus_zpwo3 the bindings (zpptrby1->zpwo1, zpptrby2->zpwo2, zpwo1->zpwo3)
    * are used in the asm, but not in the signature.
    */
   private static class FragmentBindings {

      /** Bindings used for renaming in the sub-signature. */
      private Map<String, String> sigBindings;
      /** Bindings used for renaming in the assembler-code. */
      private Map<String, String> asmBindings;


   }



   /**
    * AsmFragment synthesis based on matching fragment signature and reusing another fragment with added prefix/postfix and some bind-mappings
    */
   private static class FragmentSynthesis {

      private String sigMatch;
      private String sigAvoid;
      private String asmPrefix;
      private String sigReplace;
      private String asmPostfix;
      private Map<String, String> bindMappings;
      private String subSignature;

      public FragmentSynthesis(String sigMatch, String sigAvoid, String asmPrefix, String sigReplace, String asmPostfix, Map<String, String> bindMappings) {
         this.sigMatch = sigMatch;
         this.sigAvoid = sigAvoid;
         this.asmPrefix = asmPrefix;
         this.sigReplace = sigReplace;
         this.asmPostfix = asmPostfix;
         this.bindMappings = bindMappings;
      }

      public CharStream synthesize(String signature, CompileLog log) {
         if (signature.matches(sigMatch)) {
            if (sigAvoid == null || !signature.matches(sigAvoid)) {
               subSignature = regexpRewriteSignature(signature, sigMatch, sigReplace);
               if (bindMappings != null) {
                  for (String bound : bindMappings.keySet()) {
                     subSignature = subSignature.replace(bound, bindMappings.get(bound));
                  }
               }
               CharStream subCharStream = loadOrSynthesizeFragment(subSignature, log);
               if (subCharStream != null) {
                  StringBuilder newFragment = new StringBuilder();
                  if (asmPrefix != null) {
                     newFragment.append(asmPrefix);
                  }
                  String subFragment = subCharStream.toString();
                  if (bindMappings != null) {
                     List<String> reverse = new ArrayList<>(bindMappings.keySet());
                     Collections.reverse(reverse);
                     for (String bound : reverse) {
                        subFragment = subFragment.replace(bindMappings.get(bound), bound);
                     }
                  }
                  newFragment.append(subFragment);
                  if (asmPostfix != null) {
                     newFragment.append("\n");
                     newFragment.append(asmPostfix);
                  }
                  return CharStreams.fromString(newFragment.toString());
               }
            }
         }
         return null;
      }

      public String getSubSignature() {
         return subSignature;
      }
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
   public static KickCParser.AsmFileContext parseFragment(CharStream fragmentCharStream, final String fragmentFileName) {
      KickCLexer kickCLexer = new KickCLexer(fragmentCharStream);
      KickCParser kickCParser = new KickCParser(new CommonTokenStream(kickCLexer));
      kickCParser.addErrorListener(new BaseErrorListener() {
         @Override
         public void syntaxError(Recognizer<?, ?> recognizer, Object offendingSymbol, int line, int charPositionInLine, String msg, RecognitionException e) {
            throw new RuntimeException("Error parsing fragment " + fragmentFileName + "\n - Line: " + line + "\n - Message: " + msg);
         }
      });
      kickCParser.setBuildParseTree(true);
      KickCParser.AsmFileContext asmFileContext = kickCParser.asmFile();
      return asmFileContext;
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
