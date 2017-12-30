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

      Map<String, String> mapZ = new LinkedHashMap<>();
      mapZ.put("z2", "z1");
      mapZ.put("z3", "z2");
      Map<String, String> mapZ2 = new LinkedHashMap<>();
      mapZ2.put("z3", "z1");
      Map<String, String> mapZ3 = new LinkedHashMap<>();
      mapZ3.put("z3", "z2");
      Map<String, String> mapC = new LinkedHashMap<>();
      mapC.put("c2", "c1");
      mapC.put("c3", "c2");
      Map<String, String> mapC3 = new LinkedHashMap<>();
      mapC3.put("c3", "c2");
      Map<String, String> mapZC = new LinkedHashMap<>();
      mapZC.putAll(mapZ);
      mapZC.putAll(mapC);
      Map<String, String> mapSToU = new LinkedHashMap<>();
      mapSToU.put("vbsz1", "vbuz1");
      mapSToU.put("vbsz2", "vbuz2");
      mapSToU.put("vbsz3", "vbuz3");
      mapSToU.put("vbsc1", "vbuc1");
      mapSToU.put("vbsc2", "vbuc2");
      mapSToU.put("vbsc3", "vbuc3");
      mapSToU.put("vbsaa", "vbuaa");
      mapSToU.put("vbsxx", "vbuxx");
      mapSToU.put("vbsyy", "vbuyy");
      mapSToU.put("vwsz1", "vwuz1");
      mapSToU.put("vwsz2", "vwuz2");
      mapSToU.put("vwsz3", "vwuz3");
      mapSToU.put("vwsc1", "vwuc1");
      mapSToU.put("vwsc2", "vwuc2");
      mapSToU.put("vwsc3", "vwuc3");

      List<FragmentSynthesis> synths = new ArrayList<>();

      synths.add(new FragmentSynthesis("(.*)=(.*)_(band|bor|bxor|plus)_(vb.aa)", ".*=vb.aa_.*", null, "$1=$4_$3_$2", null, null));
      synths.add(new FragmentSynthesis("(.*)=(.*)_(band|bor|bxor|plus)_(vb.xx)", ".*=vb.[ax][ax]_.*", null, "$1=$4_$3_$2", null, null));
      synths.add(new FragmentSynthesis("(.*)=(.*)_(band|bor|bxor|plus)_(vb.yy)", ".*=vb.[axy][axy]_.*", null, "$1=$4_$3_$2", null, null));

      synths.add(new FragmentSynthesis("vbuxx=(.*)", null, null, "vbuaa=$1", "tax\n", null));
      synths.add(new FragmentSynthesis("vbsxx=(.*)", null, null, "vbsaa=$1", "tax\n", null));
      synths.add(new FragmentSynthesis("vbuyy=(.*)", null, null, "vbuaa=$1", "tay\n", null));
      synths.add(new FragmentSynthesis("vbsyy=(.*)", null, null, "vbsaa=$1", "tay\n", null));
      synths.add(new FragmentSynthesis("vbuz1=(.*)", ".*=.*vb.z1.*", null, "vbuaa=$1", "sta {z1}\n", mapZ));
      synths.add(new FragmentSynthesis("vbsz1=(.*)", ".*=.*vb.z1.*", null, "vbsaa=$1", "sta {z1}\n", mapZ));
      synths.add(new FragmentSynthesis("_deref_pb(.)c1=(.*)", null, null, "vb$1aa=$2", "sta {c1}\n", mapC));
      synths.add(new FragmentSynthesis("_deref_pbuz1=(.*)", ".*=.*z1.*", null, "vbuaa=$1", "ldy #0\n" + "sta ({z1}),y\n", mapZ));

      synths.add(new FragmentSynthesis("pb(.)c1_derefidx_vbuz1=(.*)", ".*z1.*z1.*|.*c1.*c1.*", null, "vb$1aa=$2", "ldx {z1}\n"+"sta {c1},x\n", mapZC));
      synths.add(new FragmentSynthesis("pb(.)c1_derefidx_vbuyy=(.*)", ".*c1.*c1.*", null, "vb$1aa=$2", "sta {c1},y\n", mapC));
      synths.add(new FragmentSynthesis("pb(.)c1_derefidx_vbuxx=(.*)", ".*c1.*c1.*", null, "vb$1aa=$2", "sta {c1},x\n", mapC));
      synths.add(new FragmentSynthesis("pb(.)z1_derefidx_vbuz2=(.*)", ".*z1.*z1.*|.*z2.*z2.*", null, "vb$1aa=$2", "ldy {z2}\n"+"sta ({z1}),y\n", mapZ2));

      synths.add(new FragmentSynthesis("(.*)=_deref_pb(.)c1(.*)", ".*=.*aa.*", "lda {c1}\n", "$1=vb$2aa$3", null, mapC));
      synths.add(new FragmentSynthesis("(.*)=_deref_pb(.)z1(.*)", ".*z1.*z1.*|.*=.*aa.*|.*=.*yy.*", "ldy #0\n" + "lda ({z1}),y\n", "$1=vb$2aa$3", null, mapZ));

      // Convert array indexing with A register to X/Y register by prefixing tax/tay (..._derefidx_vbuaa... -> ..._derefidx_vbuxx... /... _derefidx_vbuyy... )
      synths.add(new FragmentSynthesis("(.*)=(.*)_derefidx_vbuaa(.*)", ".*=.*xx.*", "tax\n", "$1=$2_derefidx_vbuxx$3", null, null));
      synths.add(new FragmentSynthesis("(.*)=(.*)_derefidx_vbuaa(.*)", ".*=.*yy.*", "tay\n", "$1=$2_derefidx_vbuyy$3", null, null));
      // Convert array indexing with zero page to x/y register by prefixing ldx z1 / ldy z1 ( ..._derefidx_vbuzn... -> ..._derefidx_vbuxx... / ..._derefidx_vbuyy... )
      synths.add(new FragmentSynthesis("(.*)=(.*)_derefidx_vbuz1(.*)", ".*=.*xx.*|.*z1.*z1.*", "ldx {z1}\n", "$1=$2_derefidx_vbuxx$3", null, mapZ));
      synths.add(new FragmentSynthesis("(.*)=(.*)_derefidx_vbuz1(.*)", ".*=.*yy.*|.*z1.*z1.*", "ldy {z1}\n", "$1=$2_derefidx_vbuyy$3", null, mapZ));
      synths.add(new FragmentSynthesis("(.*)=(.*)_derefidx_vbuz2(.*)", ".*=.*xx.*|.*z2.*z2.*", "ldx {z2}\n", "$1=$2_derefidx_vbuxx$3", null, mapZ3));
      synths.add(new FragmentSynthesis("(.*)=(.*)_derefidx_vbuz2(.*)", ".*=.*yy.*|.*z2.*z2.*", "ldy {z2}\n", "$1=$2_derefidx_vbuyy$3", null, mapZ3));
      synths.add(new FragmentSynthesis("(.*)=(.*)_derefidx_vbuz3(.*)", ".*=.*yy.*", "ldy {z3}\n", "$1=$2_derefidx_vbuyy$3", null, null));
      synths.add(new FragmentSynthesis("(.*)=(.*)_derefidx_vbuz3(.*)", ".*=.*xx.*", "ldx {z3}\n", "$1=$2_derefidx_vbuxx$3", null, null));
      // Convert array indexing twice with A/zp1/zp2 to X/Y register with a ldx/ldy prefix ( ..._derefidx_vbunn..._derefidx_vbunn... -> ..._derefidx_vbuxx..._derefidx_vbuxx... )
      synths.add(new FragmentSynthesis("(.*)_derefidx_vbuaa(.*)_derefidx_vbuaa(.*)", ".*aa.*aa.*aa.*|.*xx.*", null, "$1_derefidx_vbuxx$2_derefidx_vbuxx$3", "tax\n", null));
      synths.add(new FragmentSynthesis("(.*)_derefidx_vbuaa(.*)_derefidx_vbuaa(.*)", ".*aa.*aa.*aa.*|.*yy.*", null, "$1_derefidx_vbuyy$2_derefidx_vbuyy$3", "tay\n", null));
      synths.add(new FragmentSynthesis("(.*)_derefidx_vbuz1(.*)_derefidx_vbuz1(.*)", ".*z1.*z1.*z1.*|.*xx.*", null, "$1_derefidx_vbuxx$2_derefidx_vbuxx$3", "ldx {z1}\n", mapZ));
      synths.add(new FragmentSynthesis("(.*)_derefidx_vbuz1(.*)_derefidx_vbuz1(.*)", ".*z1.*z1.*z1.*|.*yy.*", null, "$1_derefidx_vbuyy$2_derefidx_vbuyy$3", "ldy {z1}\n", mapZ));
      synths.add(new FragmentSynthesis("(.*)_derefidx_vbuz2(.*)_derefidx_vbuz2(.*)", ".*z2.*z2.*z2.*|.*xx.*", null, "$1_derefidx_vbuxx$2_derefidx_vbuxx$3", "ldx {z2}\n", mapZ));
      synths.add(new FragmentSynthesis("(.*)_derefidx_vbuz2(.*)_derefidx_vbuz2(.*)", ".*z2.*z2.*z2.*|.*yy.*", null, "$1_derefidx_vbuyy$2_derefidx_vbuyy$3", "ldy {z2}\n", mapZ));
      synths.add(new FragmentSynthesis("pb(.)c1_derefidx_vbuz1=(.*c1.*)", ".*z1.*z1.*", null, "vb$1aa=$2", "ldx {z1}\n"+"sta {c1},x\n", mapZ));
      synths.add(new FragmentSynthesis("pb(.)c1_derefidx_vbuz1=(.*z1.*)", ".*c1.*c1.*", null, "vb$1aa=$2", "ldx {z1}\n"+"sta {c1},x\n", mapC));

      // Convert X/Y-based array indexing of a constant pointer into A-register by prefixing lda cn,x / lda cn,y ( ...pb.c1_derefidx_vbuxx... / ...pb.c1_derefidx_vbuyy... -> ...vb.aa... )
      synths.add(new FragmentSynthesis("(.*)=(.*)pb(.)c1_derefidx_vbuxx(.*)", ".*=.*aa.*|.*c1.*c1.*", "lda {c1},x\n", "$1=$2vb$3aa$4", null, mapC));
      synths.add(new FragmentSynthesis("(.*)=(.*c1.*)pb(.)c1_derefidx_vbuxx(.*)", ".*=.*aa.*", "lda {c1},x\n", "$1=$2vb$3aa$4", null, null));
      synths.add(new FragmentSynthesis("(.*)=(.*)pb(.)c1_derefidx_vbuxx(.*c1.*)", ".*=.*aa.*", "lda {c1},x\n", "$1=$2vb$3aa$4", null, null));
      synths.add(new FragmentSynthesis("(.*)=(.*)pb(.)c1_derefidx_vbuyy(.*)", ".*=.*aa.*|.*c1.*c1.*", "lda {c1},y\n", "$1=$2vb$3aa$4", null, mapC));
      synths.add(new FragmentSynthesis("(.*)=(.*c1.*)pb(.)c1_derefidx_vbuyy(.*)", ".*=.*aa.*", "lda {c1},y\n", "$1=$2vb$3aa$4", null, null));
      synths.add(new FragmentSynthesis("(.*)=(.*)pb(.)c1_derefidx_vbuyy(.*c1.*)", ".*=.*aa.*", "lda {c1},y\n", "$1=$2vb$3aa$4", null, null));
      synths.add(new FragmentSynthesis("(.*)=(.*)pb(.)c2_derefidx_vbuxx(.*)", ".*=.*aa.*|.*c2.*c2.*", "lda {c2},x\n", "$1=$2vb$3aa$4", null, mapC3));
      synths.add(new FragmentSynthesis("(.*)=(.*c2.*)pb(.)c2_derefidx_vbuxx(.*)", ".*=.*aa.*", "lda {c2},x\n", "$1=$2vb$3aa$4", null, null));
      synths.add(new FragmentSynthesis("(.*)=(.*)pb(.)c2_derefidx_vbuxx(.*c2.*)", ".*=.*aa.*", "lda {c2},x\n", "$1=$2vb$3aa$4", null, null));
      synths.add(new FragmentSynthesis("(.*)=(.*)pb(.)c2_derefidx_vbuyy(.*)", ".*=.*aa.*|.*c2.*c2.*", "lda {c2},y\n", "$1=$2vb$3aa$4", null, mapC3));
      synths.add(new FragmentSynthesis("(.*)=(.*c2.*)pb(.)c2_derefidx_vbuyy(.*)", ".*=.*aa.*", "lda {c2},y\n", "$1=$2vb$3aa$4", null, null));
      synths.add(new FragmentSynthesis("(.*)=(.*)pb(.)c2_derefidx_vbuyy(.*c2.*)", ".*=.*aa.*", "lda {c2},y\n", "$1=$2vb$3aa$4", null, null));

      // Convert zeropage/constants/X/Y in assignments to A-register using LDA/TXA/TYA prefix
      synths.add(new FragmentSynthesis("(.*)=(.*)vbuz1(.*)", ".*z1.*=.*|.*=.*aa.*|.*z1.*z1.*", "lda {z1}\n", "$1=$2vbuaa$3", null, mapZ));
      synths.add(new FragmentSynthesis("(.*)=(.*)vbsz1(.*)", ".*z1.*=.*|.*=.*aa.*|.*z1.*z1.*", "lda {z1}\n", "$1=$2vbsaa$3", null, mapZ));
      synths.add(new FragmentSynthesis("(.*)=(.*)vbuz2(.*)", ".*z2.*=.*|.*=.*aa.*|.*z2.*z2.*|.*z3.*", "lda {z2}\n", "$1=$2vbuaa$3", null, null));
      synths.add(new FragmentSynthesis("(.*)=(.*)vbsz2(.*)", ".*z2.*=.*|.*=.*aa.*|.*z2.*z2.*|.*z3.*", "lda {z2}\n", "$1=$2vbsaa$3", null, null));
      synths.add(new FragmentSynthesis("(.*)=(.*)vbuz2(.*z3.*)", ".*z2.*=.*|.*=.*aa.*|.*z2.*z2.*|.*z3.*", "lda {z2}\n", "$1=$2vbuaa$3", null, mapZ3));
      synths.add(new FragmentSynthesis("(.*)=(.*)vbsz2(.*z3.*)", ".*z2.*=.*|.*=.*aa.*|.*z2.*z2.*|.*z3.*", "lda {z2}\n", "$1=$2vbsaa$3", null, mapZ3));

      synths.add(new FragmentSynthesis("(.*)=(.*)_vbuxx", ".*=.*[ax][ax].*xx|.*derefidx_vb.xx", "txa\n", "$1=$2_vbuaa", null, null));
      synths.add(new FragmentSynthesis("(.*)=(.*)_vbsxx", ".*=.*[ax][ax].*xx|.*derefidx_vb.xx", "txa\n", "$1=$2_vbsaa", null, null));
      synths.add(new FragmentSynthesis("(.*)=(.*)_vbuyy", ".*=.*[ay][ay].*yy|.*derefidx_vb.yy", "tya\n", "$1=$2_vbuaa", null, null));
      synths.add(new FragmentSynthesis("(.*)=(.*)_vbsyy", ".*=-*[ay][ay].*yy|.*derefidx_vb.yy", "tya\n", "$1=$2_vbsaa", null, null));
      synths.add(new FragmentSynthesis("(.*)=(.*)_vbuz1", ".*=.*aa.*|.*z1.*z1.*", "lda {z1}\n", "$1=$2_vbuaa", null, mapZ));
      synths.add(new FragmentSynthesis("(.*)=(.*)_vbsz1", ".*=.*aa.*|.*z1.*z1.*", "lda {z1}\n", "$1=$2_vbsaa", null, mapZ));
      synths.add(new FragmentSynthesis("(.*)=(.*)_vbuz2", ".*=.*aa.*|.*z2.*z2.*", "lda {z2}\n", "$1=$2_vbuaa", null, null));
      synths.add(new FragmentSynthesis("(.*)=(.*)_vbuz3", ".*=.*aa.*|.*z3.*z3.*", "lda {z3}\n", "$1=$2_vbuaa", null, null));

      synths.add(new FragmentSynthesis("vbuz1=vbuz1(.*)", ".*=.*vb.aa.*|.*z1.*z1.*z1.*", "lda {z1}\n", "vbuaa=vbuaa$1", "sta {z1}\n", mapZ));
      synths.add(new FragmentSynthesis("vbsz1=vbsz1(.*)", ".*=.*vb.aa.*|.*z1.*z1.*z1.*", "lda {z1}\n", "vbsaa=vbsaa$1", "sta {z1}\n", mapZ));

      synths.add(new FragmentSynthesis("vbuz1_(lt|gt|le|ge|eq|neq)_(.*)", ".*vb.aa.*", "lda {z1}\n", "vbuaa_$1_$2", null, mapZ));
      synths.add(new FragmentSynthesis("vbsz1_(lt|gt|le|ge|eq|neq)_(.*)", ".*vb.aa.*", "lda {z1}\n", "vbsaa_$1_$2", null, mapZ));
      synths.add(new FragmentSynthesis("_deref_pb(.)c1_(lt|gt|le|ge|eq|neq)_(.*)", ".*vb.aa.*", "lda {c1}\n", "vb$1aa_$2_$3", null, mapC));
      synths.add(new FragmentSynthesis("_deref_pb(.)z1_(lt|gt|le|ge|eq|neq)_(.*)", ".*vb.aa.*|.*vb.yy.*|.*z1.*z1.*", "ldy #0\n" + "lda ({z1}),y\n", "vb$1aa_$2_$3", null, mapZ));

      synths.add(new FragmentSynthesis("(.*)_derefidx_vbuz1_(lt|gt|le|ge|eq|neq)_(.*)", ".*z1.*z1.*|.*vb.yy.*", "ldy {z1}\n", "$1_derefidx_vbuyy_$2_$3", null, mapZ));
      synths.add(new FragmentSynthesis("(.*)_derefidx_vbuz1_(lt|gt|le|ge|eq|neq)_(.*)", ".*z1.*z1.*|.*vb.xx.*", "ldx {z1}\n", "$1_derefidx_vbuxx_$2_$3", null, mapZ));
      synths.add(new FragmentSynthesis("pb(.)c1_derefidx_vbuyy_(lt|gt|le|ge|eq|neq)_(.*)", ".*c1.*c1.*|.*aa.*", "lda {c1},y\n", "vb$1aa_$2_$3", null, mapC));
      synths.add(new FragmentSynthesis("pb(.)c1_derefidx_vbuyy_(lt|gt|le|ge|eq|neq)_(.*c1.*)", ".*aa.*", "lda {c1},y\n", "vb$1aa_$2_$3", null, null));
      synths.add(new FragmentSynthesis("pb(.)c1_derefidx_vbuxx_(lt|gt|le|ge|eq|neq)_(.*)", ".*c1.*c1.*|.*aa.*", "lda {c1},x\n", "vb$1aa_$2_$3", null, mapC));
      synths.add(new FragmentSynthesis("pb(.)c1_derefidx_vbuxx_(lt|gt|le|ge|eq|neq)_(.*c1.*)", ".*aa.*", "lda {c1},x\n", "vb$1aa_$2_$3", null, null));

      synths.add(new FragmentSynthesis("(.*)_ge_(vb.aa)_then_(.*)", ".*vb.aa.*_ge.*", null, "$2_lt_$1_then_$3", null, null));
      synths.add(new FragmentSynthesis("(.*)_ge_(vb.xx)_then_(.*)", ".*vb.[ax][ax].*_ge.*", null, "$2_lt_$1_then_$3", null, null));
      synths.add(new FragmentSynthesis("(.*)_ge_(vb.yy)_then_(.*)", ".*vb.[axy][axy].*_ge.*", null, "$2_lt_$1_then_$3", null, null));
      synths.add(new FragmentSynthesis("(.*)_lt_(vb.aa)_then_(.*)", ".*vb.aa.*_lt.*", null, "$2_ge_$1_then_$3", null, null));
      synths.add(new FragmentSynthesis("(.*)_lt_(vb.xx)_then_(.*)", ".*vb.[ax][ax].*_lt.*", null, "$2_ge_$1_then_$3", null, null));
      synths.add(new FragmentSynthesis("(.*)_lt_(vb.yy)_then_(.*)", ".*vb.[axy][axy].*_lt.*", null, "$2_ge_$1_then_$3", null, null));
      synths.add(new FragmentSynthesis("(.*)_gt_(vb.aa)_then_(.*)", ".*vb.aa.*_gt.*", null, "$2_le_$1_then_$3", null, null));
      synths.add(new FragmentSynthesis("(.*)_gt_(vb.xx)_then_(.*)", ".*vb.[ax][ax].*_gt.*", null, "$2_le_$1_then_$3", null, null));
      synths.add(new FragmentSynthesis("(.*)_gt_(vb.yy)_then_(.*)", ".*vb.[axy][axy].*_gt.*", null, "$2_le_$1_then_$3", null, null));
      synths.add(new FragmentSynthesis("(.*)_le_(vb.aa)_then_(.*)", ".*vb.aa.*_le.*", null, "$2_gt_$1_then_$3", null, null));
      synths.add(new FragmentSynthesis("(.*)_le_(vb.xx)_then_(.*)", ".*vb.[ax][ax].*_le.*", null, "$2_gt_$1_then_$3", null, null));
      synths.add(new FragmentSynthesis("(.*)_le_(vb.yy)_then_(.*)", ".*vb.[axy][axy].*_le.*", null, "$2_gt_$1_then_$3", null, null));
      synths.add(new FragmentSynthesis("(.*)_neq_(vb.aa)_then_(.*)", ".*vb.aa.*_neq.*", null, "$2_neq_$1_then_$3", null, null));
      synths.add(new FragmentSynthesis("(.*)_neq_(vb.xx)_then_(.*)", ".*vb.[ax][ax].*_neq.*", null, "$2_neq_$1_then_$3", null, null));
      synths.add(new FragmentSynthesis("(.*)_neq_(vb.yy)_then_(.*)", ".*vb.[axy][axy].*_neq.*", null, "$2_neq_$1_then_$3", null, null));
      synths.add(new FragmentSynthesis("(.*)_eq_(vb.aa)_then_(.*)", ".*vb.aa.*_eq.*", null, "$2_eq_$1_then_$3", null, null));
      synths.add(new FragmentSynthesis("(.*)_eq_(vb.xx)_then_(.*)", ".*vb.[ax][ax].*_eq.*", null, "$2_eq_$1_then_$3", null, null));
      synths.add(new FragmentSynthesis("(.*)_eq_(vb.yy)_then_(.*)", ".*vb.[axy][axy].*_eq.*", null, "$2_eq_$1_then_$3", null, null));

      // Use unsigned ASM to synthesize signed ASM ( ...vbs... -> ...vbu... )
      synths.add(new FragmentSynthesis("(vbsz.|vbsc.|vbsaa|vbsxx|vbsyy)_(eq|neq)_(vbsz.|vbsc.|vbsaa|vbsxx|vbsyy)_then_(.*)", null, null, "$1_$2_$3_then_$4", null, mapSToU));
      synths.add(new FragmentSynthesis("(vbsz.|vbsc.|vbsaa|vbsxx|vbsyy)=(vbsz.|vbsc.|vbsaa|vbsxx|vbsyy)", null, null, "$1=$2", null, mapSToU));
      synths.add(new FragmentSynthesis("(vbsz.|vbsc.|vbsaa|vbsxx|vbsyy)=(vbsz.|vbsc.|vbsaa|vbsxx|vbsyy)_(plus|band|bxor|bor)_(vbsz.|csoby.|vbsaa|vbsxx|vbsyy)", null, null, "$1=$2_$3_$4", null, mapSToU));
      synths.add(new FragmentSynthesis("(vbsz.|vbsc.|vbsaa|vbsxx|vbsyy)=_(inc|dec)_(vbsz.|vbsc.|vbsaa|vbsxx|vbsyy)", null, null, "$1=_$2_$3", null, mapSToU));
      synths.add(new FragmentSynthesis("(vwsz.|vwsc.)_(eq|neq)_(vwsz.|vwsc.)_then_(.*)", null, null, "$1_$2_$3_then_$4", null, mapSToU));
      synths.add(new FragmentSynthesis("(vwsz.)=(vwsz.|vwsc.)", null, null, "$1=$2", null, mapSToU));
      synths.add(new FragmentSynthesis("(v.sz.)=(v.s..)_(band|bxor|bor)_(v.s..)", null, null, "$1=$2_$3_$4", null, mapSToU));
      synths.add(new FragmentSynthesis("(vbuz.|vbuaa|vbuxx|vbuyy)=_(lo|hi)_vws(z.|c.)", null, null, "$1=_$2_vwu$3", null, mapSToU));

      // Use constant word ASM to synthesize unsigned constant byte ASM ( ...vb.c... -> vw.c... )
      synths.add(new FragmentSynthesis("(vwuz.)=(vwuz.)_(plus|minus|band|bxor|bor)_vb.c(.)", null, null, "$1=$2_$3_vwuc$4", null, null));
      synths.add(new FragmentSynthesis("(vwuz.)=vb.c(.)_(plus|minus|band|bxor|bor)_(vwuz.)", null, null, "$1=vwuc$2_$3_$4", null, null));
      synths.add(new FragmentSynthesis("(vwsz.)=(vwsz.)_(plus|minus|band|bxor|bor)_vb.c(.)", null, null, "$1=$2_$3_vwsc$4", null, null));
      synths.add(new FragmentSynthesis("(vwsz.)=vb.c(.)_(plus|minus|band|bxor|bor)_(vwsz.)", null, null, "$1=vwsc$2_$3_$4", null, null));

      // Move constant words to the end of the ASM signature for symmetric operators ( ...vw.c...vw.z... -> ...vw.z...vw.c... )
      synths.add(new FragmentSynthesis("(vwuz.)=(vwuc.)_(plus|band|bxor|bor)_(vwuz.)", null, null, "$1=$4_$3_$2", null, null));
      synths.add(new FragmentSynthesis("(vwsz.)=(vwsc.)_(plus|band|bxor|bor)_(vwsz.)", null, null, "$1=$4_$3_$2", null, null));

      // Use Z1/Z2 ASM to synthesize Z1-only code ( ...z1...z1... -> ...z1...z2... )
      synths.add(new FragmentSynthesis("(v..)z1=(v..)z1_(plus|minus|band|bxor|bor)_(.*)", ".*z2.*", null, "$1z1=$2z2_$3_$4", null, mapZ, false));
      synths.add(new FragmentSynthesis("(v..)z1=(.*)_(plus|minus|band|bxor|bor)_(v..)z1", ".*z2.*", null, "$1z1=$2_$3_$4z2", null, mapZ, false));
      synths.add(new FragmentSynthesis("(v..)z1=_(neg|lo|hi)_(v..)z1", ".*z2.*", null, "$1z1=_$2_$3z2", null, mapZ, false));

      // Convert INC/DEC to +1/-1 ( ..._inc_xxx... -> ...xxx_plus_1_... / ..._dec_xxx... -> ...xxx_minus_1_... )
      synths.add(new FragmentSynthesis("vb(.)aa=_inc_(.*)", null, null, "vb$1aa=$2_plus_1", null, null));
      synths.add(new FragmentSynthesis("vb(.)aa=_dec_(.*)", null, null, "vb$1aa=$2_minus_1", null, null));

      // Synthesize XX/YY using AA
      synths.add(new FragmentSynthesis("(.*)=(.*)vbuxx(.*)", ".*=.*aa.*|.*derefidx_vb.xx.*", "txa\n", "$1=$2vbuaa$3", null, null));
      synths.add(new FragmentSynthesis("(.*)=(.*)vbsxx(.*)", ".*=.*aa.*|.*derefidx_vb.xx.*", "txa\n", "$1=$2vbsaa$3", null, null));
      synths.add(new FragmentSynthesis("(.*)=(.*)vbuyy(.*)", ".*=.*aa.*|.*derefidx_vb.yy.*", "tya\n", "$1=$2vbuaa$3", null, null));
      synths.add(new FragmentSynthesis("(.*)=(.*)vbsyy(.*)", ".*=.*aa.*|.*derefidx_vb.yy.*", "tya\n", "$1=$2vbsaa$3", null, null));
      // Synthesize constants using AA
      synths.add(new FragmentSynthesis("(.*)=(.*)vbuc1(.*)", ".*=.*aa.*|.*c1.*c1.*|.*c1_deref.*", "lda #{c1}\n", "$1=$2vbuaa$3", null, mapC));
      synths.add(new FragmentSynthesis("(.*)=(.*)vbsc1(.*)", ".*=.*aa.*|.*c1.*c1.*|.*c1_deref.*", "lda #{c1}\n", "$1=$2vbsaa$3", null, mapC));

      // Synthesize some constant pointers as constant words
      synths.add(new FragmentSynthesis("(.*)_(lt|gt|le|ge|eq|neq)_p..([cz].)_then_(.*)", null, null, "$1_$2_vwu$3_then_$4", null, null));
      synths.add(new FragmentSynthesis("p..([cz].)_(lt|gt|le|ge|eq|neq)_(.*)", null, null, "vwu$1_$2_$3", null, null));
      synths.add(new FragmentSynthesis("(.*)=p..([zc].)", null, null, "$1=vwu$2", null, null));
      synths.add(new FragmentSynthesis("(.*)=(.*)_(plus|minus|bor|bxor)_p..([cz].)", null, null, "$1=$2_$3_vwu$4", null, null));
      synths.add(new FragmentSynthesis("(.*)=p..([cz].)_(plus|minus|bor|bxor)_(.*)", null, null, "$1=vwu$2_$3_$4", null, null));
      synths.add(new FragmentSynthesis("p..([cz].)=(.*)_(sethi|setlo|plus|minus)_(.*)", null, null, "vwu$1=$2_$3_$4", null, null));
      synths.add(new FragmentSynthesis("(.*)=p..([cz].)_(sethi|setlo|plus|minus)_(.*)", null, null, "$1=vwu$2_$3_$4", null, null));



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
    * Eg. when synthesizing vbuz1=vbuz2_plus_vbuz3 from vbuaa=vbuz1_plus_vbuz2 the bindings (vbuz2->vbuz1, vbuz3->vbuz2) are used.
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
      private boolean mapSignature;

      public FragmentSynthesis(String sigMatch, String sigAvoid, String asmPrefix, String sigReplace, String asmPostfix, Map<String, String> bindMappings, boolean mapSignature) {
         this.sigMatch = sigMatch;
         this.sigAvoid = sigAvoid;
         this.asmPrefix = asmPrefix;
         this.sigReplace = sigReplace;
         this.asmPostfix = asmPostfix;
         this.bindMappings = bindMappings;
         this.mapSignature = mapSignature;
      }

      public FragmentSynthesis(String sigMatch, String sigAvoid, String asmPrefix, String sigReplace, String asmPostfix, Map<String, String> bindMappings) {
         this(sigMatch, sigAvoid, asmPrefix, sigReplace, asmPostfix, bindMappings, true);
      }

      public CharStream synthesize(String signature, CompileLog log) {
         if (signature.matches(sigMatch)) {
            if (sigAvoid == null || !signature.matches(sigAvoid)) {
               subSignature = regexpRewriteSignature(signature, sigMatch, sigReplace);
               if (mapSignature && bindMappings != null) {
                  // When mapping the signature we do the map replacement in the signature
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
                     if(mapSignature) {
                        // When mapping the signature we do the reverse replacement in the ASM
                        List<String> reverse = new ArrayList<>(bindMappings.keySet());
                        Collections.reverse(reverse);
                        for (String bound : reverse) {
                           subFragment = subFragment.replace("{" + bindMappings.get(bound) + "}", "{" + bound + "}");
                        }
                     } else {
                        // When not mapping the signature we do the replacement directly in the ASM
                        for (String bound : bindMappings.keySet()) {
                           subFragment = subFragment.replace("{" + bound + "}", "{" + bindMappings.get(bound) + "}");
                        }
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
